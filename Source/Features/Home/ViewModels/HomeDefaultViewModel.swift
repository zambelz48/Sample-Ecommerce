//
//  HomeDefaultViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

final class HomeDefaultViewModel : HomeViewModel {
	
	var productCategoriesCount: Int {
		return productCategoryViewModel.dataCount
	}
	var productsCount: Int {
		return productListViewModel.dataCount
	}
	
	var fetchDataSuccessObservable: Observable<Void> {
		return fetchDataSuccessSubject.asObservable()
	}
	var fetchDataErrorObservable: Observable<Error> {
		return fetchDataErrorSubject.asObservable()
	}
	
	private let productCategoryViewModel: ProductCategoryViewModel
	private let productListViewModel: ProductListViewModel
	
	private let disposeBag = DisposeBag()
	private let triggerFetch = PublishSubject<Void>()
	private let fetchDataSuccessSubject = PublishSubject<Void>()
	private let fetchDataErrorSubject = PublishSubject<Error>()
	
	private let productRepository: ProductRepository
	
	init(productRepository: ProductRepository) {
		
		self.productRepository = productRepository
		
		self.productCategoryViewModel = ProductCategoryDefaultViewModel()
		self.productListViewModel =  ProductListDefaultViewModel()
		
		bindFetchDataSubscription()
	}
	
	func fetchData() {
		triggerFetch.onNext(())
	}
	
	func productItemViewModel(at index: Int) -> ProductItemViewModel {
		return productListViewModel.itemViewModel(at: index)
	}
	
	func productCategoryViewModel(at index: Int) -> ProductCategoryItemViewModel {
		return productCategoryViewModel.itemViewModel(at: index)
	}
	
	func productId(at index: Int) -> String {
		
		let productIdRelay = productItemViewModel(at: index).productId
		
		return productIdRelay.value
	}
	
	private func bindFetchDataSubscription() {
		
		triggerFetch.asObservable()
			.flatMap { [weak self] _ -> Observable<ProductResponse> in
				
				guard let self = self else {
					return .error(ErrorFactory.unknown)
				}
				
				return self.productRepository.getData()
			}
			.subscribe(
				onNext: { [weak self] (data: ProductResponse) in
					
					self?.configureProductCategories(from: data)
					
					self?.configureProducts(from: data)
					
					self?.fetchDataSuccessSubject.onNext(())
				},
				onError: fetchDataErrorSubject.onNext
			)
			.disposed(by: disposeBag)
	}
	
	private func configureProductCategories(from response: ProductResponse) {
		productCategoryViewModel.add(categories: response.category)
	}
	
	private func configureProducts(from response: ProductResponse) {
		productListViewModel.add(products: response.productPromo)
	}
	
}
