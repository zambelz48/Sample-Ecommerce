//
//  ProductDefaultRepository.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

final class ProductDefaultRepository : ProductRepository {
	
	private let productsLocalKey = "Products"
	private let productCategoriesLocalKey = "ProductCategories"
	
	private let disposeBag = DisposeBag()
	
	private let httpHandler: HttpHandler
	private let localStorage = SimpleLocalStorage.shared
	
	init(httpHandler: HttpHandler) {
		self.httpHandler = httpHandler
	}
	
	// MARK: - ProductRepository

	func getData() -> Observable<ProductResponse> {
		
		let isProductsLocalDataExists = localStorage.isDataExists(productsLocalKey)
		let isProductCategoriesLocalDataExists = localStorage.isDataExists(productsLocalKey)
		
		guard isProductsLocalDataExists && isProductCategoriesLocalDataExists else {
			return getDataFromNetwork()
		}
		
		return getProductsFromLocal().flatMap { [weak self] (products: [Product]) -> Observable<ProductResponse> in
			
			guard let self = self else {
				return .error(ErrorFactory.unknown)
			}
			
			return self.getProductCategoriesFromLocal()
				.map ({ (productCategories: [ProductCategory]) -> ProductResponse in
					
					let productResponse = ProductResponse(
						category: productCategories,
						productPromo: products
					)
					
					return productResponse
				})
		}
	}
	
	func getProduct(id: String) -> Observable<Product> {
		
		return getProductsFromLocal().flatMap { (products: [Product]) -> Observable<Product> in
			
			let filteredProducts = products.filter({ (product: Product) -> Bool in
				return product.id == id
			})
			
			guard let product = filteredProducts.first else {
				return .error(ErrorFactory.unknown)
			}
			
			return .of(product)
		}
	}
	
	func search(keyword: String) -> Observable<[Product]> {
		
		return getProductsFromLocal().flatMap { (products: [Product]) -> Observable<[Product]> in
			
			let filteredProducts = products.filter { (product: Product) -> Bool in
				return product.title.contains(keyword)
			}
			
			return .from(optional: filteredProducts)
		}
	}
	
	// MARK: - Private methods
	
	private func getDataFromNetwork() -> Observable<ProductResponse> {
		
		let endpoint = ProductEndpoint.list.rawValue
		let spec = HttpRequestSpec(url: endpoint, method: .get)
		
		typealias Response = [DataResponse<ProductResponse>]
		
		let requestObservable: Observable<Response> = httpHandler.jsonRequestObservable(spec: spec)
		
		return requestObservable
			.do(onNext: { [weak self] (response: [DataResponse<ProductResponse>]) in
				
				guard  let self = self,
					let data = response.first?.data else {
						return
				}
				
				self.localStorage.save(
					key: self.productsLocalKey,
					data: data.productPromo
				)
				
				self.localStorage.save(
					key: self.productCategoriesLocalKey,
					data: data.category
				)
			})
			.map ({ (response: Response) -> ProductResponse in
				return response[0].data
			})
	}
	
	private func getProductsFromLocal() -> Observable<[Product]> {
		
		return Observable.create { [weak self] observer -> Disposable in
			
			let disposable = Disposables.create()
			
			guard let self = self else {
				observer.onError(ErrorFactory.unknown)
				return disposable
			}
			
			self.localStorage.list(
				key: self.productsLocalKey,
				onSuccess: { (products: [Product]) in
					observer.onNext(products)
					observer.onCompleted()
				},
				onFailed: {  (error: Error) in
					observer.onError(error)
					observer.onCompleted()
				}
			)
			
			return disposable
		}
	}
	
	private func getProductCategoriesFromLocal() -> Observable<[ProductCategory]> {
		
		return Observable.create { [weak self] observer -> Disposable in
			
			let disposable = Disposables.create()
			
			guard let self = self else {
				observer.onError(ErrorFactory.unknown)
				return disposable
			}
			
			self.localStorage.list(
				key: self.productCategoriesLocalKey,
				onSuccess: { (categories: [ProductCategory]) in
					observer.onNext(categories)
					observer.onCompleted()
				},
				onFailed: {  (error: Error) in
					observer.onError(error)
					observer.onCompleted()
				}
			)
			
			return disposable
		}
	}
	
}
