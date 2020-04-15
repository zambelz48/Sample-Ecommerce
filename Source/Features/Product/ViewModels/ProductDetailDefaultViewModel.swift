//
//  ProductDetailDefaultViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class ProductDetailDefaultViewModel : ProductDetailViewModel {
	
	var purchaseSuccessObservable: Observable<Void> {
		return purchaseSuccessSubject.asObservable()
	}
	var purchaseFailedObservable: Observable<Error> {
		return purchaseFailedSubject.asObservable()
	}
	
	var productImageURLObservable: Observable<String> {
		return productImageURLRelay.asObservable()
	}
	var productLabelObservable: Observable<String> {
		return productLabelRelay.asObservable()
	}
	var isFavouriteObservable: Observable<Bool> {
		return isFavouriteRelay.asObservable()
	}
	var productDescriptionObservable: Observable<String> {
		return productDescriptionRelay.asObservable()
	}
	var productPriceObservable: Observable<String> {
		return productPriceRelay.asObservable()
	}
	
	private let disposeBag = DisposeBag()
	
	private let productIdRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
	private let productImageURLRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
	private let productLabelRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
	private let isFavouriteRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
	private let productDescriptionRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
	private let productPriceRelay: BehaviorRelay<String> = BehaviorRelay(value: "")
	private let triggerLoadSubject: PublishSubject<Void> = PublishSubject()
	
	private let purchaseSuccessSubject: PublishSubject<Void> = PublishSubject()
	private let purchaseFailedSubject: PublishSubject<Error> = PublishSubject()
	
	private let productId: String
	private let productRepository: ProductRepository
	private let orderRepository: OrderRepository
	
	init(
		productId: String,
		productRepository: ProductRepository,
		orderRepository: OrderRepository
	) {
		
		self.productId = productId
		self.productRepository = productRepository
		self.orderRepository = orderRepository
		
		bindLoadEvent()
		
		load()
	}
	
	func load() {
		triggerLoadSubject.onNext(())
	}
	
	func buy() {
		
		productRepository.getProduct(id: productId)
			.flatMap ({ [weak self] (product: Product) -> Observable<Void> in
				
				guard let self = self else {
					return .error(ErrorFactory.unknown)
				}
				
				return self.orderRepository.save(order: product)
			})
			.subscribe(
				onNext: purchaseSuccessSubject.onNext,
				onError: purchaseFailedSubject.onNext
			)
			.disposed(by: disposeBag)
	}
	
	private func bindLoadEvent() {
		
		triggerLoadSubject.asObservable()
			.flatMap({ [weak self] _ -> Observable<Product> in
				
				guard let self = self else {
					return .error(ErrorFactory.unknown)
				}
				
				return self.productRepository.getProduct(id: self.productId)
			})
			.subscribe(onNext: { (product: Product) in
				self.productIdRelay.accept(product.id)
				self.productImageURLRelay.accept(product.imageUrl)
				self.productLabelRelay.accept(product.title)
				self.isFavouriteRelay.accept(product.loved > 0)
				self.productDescriptionRelay.accept(product.description)
				self.productPriceRelay.accept(product.price)
			})
			.disposed(by: disposeBag)
	}
	
}
