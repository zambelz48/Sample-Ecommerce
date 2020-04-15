//
//  ProfileDefaultViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

final class ProfileDefaultViewModel : ProfileViewModel {
	
	var loadFinishedObservable: Observable<Void> {
		return loadFinishedSubject.asObservable()
	}
	
	var purchasedCount: Int {
		return purchasedItemViewModels.count
	}
	
	private var purchasedItemViewModels: [ProductItemViewModel] = [ProductItemViewModel]()
	
	private let disposeBag = DisposeBag()
	private let triggerLoad: PublishSubject<Void> = PublishSubject()
	private let loadFinishedSubject: PublishSubject<Void> = PublishSubject()
	
	private let orderRepository: OrderRepository
	
	init(orderRepository: OrderRepository) {
		
		self.orderRepository = orderRepository
		
		bindEvents()
		
		load()
	}
	
	func load() {
		triggerLoad.onNext(())
	}
	
	func purchasedItem(at index: Int) -> ProductItemViewModel {
		return purchasedItemViewModels[index]
	}
	
	func productId(at index: Int) -> String {
		let productIdRelay = purchasedItem(at: index).productId
		return productIdRelay.value
	}
	
	private func bindEvents() {
		
		triggerLoad.asObservable()
			.flatMap({ [weak self] _ -> Observable<[Product]> in
				
				guard let self = self else {
					return .error(ErrorFactory.unknown)
				}
				
				return self.orderRepository.getList()
			})
			.subscribe(onNext: appendResult(from:))
			.disposed(by: disposeBag)
	}
	
	private func appendResult(from products: [Product]) {
		
		if (purchasedCount > 0) {
			purchasedItemViewModels.removeAll()
		}
		
		products.forEach { [weak self] (product: Product) in
			let itemViewModel = ProductItemDefaultViewModel(product: product)
			self?.purchasedItemViewModels.append(itemViewModel)
		}
		
		loadFinishedSubject.onNext(())
	}
	
}
