//
//  ProductSearchItemDefaultViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

final class ProductSearchDefaultViewModel : ProductSearchViewModel {
	
	var resultCount: Int {
		return resultItemViewModels.count
	}
	
	var searchFinishedObservable: Observable<Void> {
		return searchFinishedSubject.asObservable()
	}
	
	private var resultItemViewModels: [ProductItemViewModel] = [ProductItemViewModel]()
	
	private let disposeBag = DisposeBag()
	private let triggerSearch: PublishSubject<String> = PublishSubject()
	private let searchFinishedSubject: PublishSubject<Void> = PublishSubject()
	private let productRepository: ProductRepository
	
	init(productRepository: ProductRepository) {
		
		self.productRepository = productRepository
		
		bindEvents()
	}
	
	func search(keyword: String) {
		triggerSearch.onNext(keyword)
	}
	
	func resultItem(at index: Int) -> ProductItemViewModel {
		return resultItemViewModels[index]
	}
	
	func productId(at index: Int) -> String {
		let productIdRelay = resultItem(at: index).productId
		return productIdRelay.value
	}
	
	private func bindEvents() {
		
		triggerSearch.asObservable()
			.throttle(.seconds(3), scheduler: MainScheduler.instance)
			.flatMap({ [weak self] (keyword:  String) -> Observable<[Product]> in
				
				guard let self = self else {
					return .error(ErrorFactory.unknown)
				}
				
				return self.productRepository.search(keyword: keyword)
			})
			.subscribe(onNext: appendResult(from:))
			.disposed(by: disposeBag)
	}
	
	private func appendResult(from products: [Product]) {
		
		if (resultCount > 0) {
			resultItemViewModels.removeAll()
		}
		
		products.forEach { [weak self] (product: Product) in
			let itemViewModel = ProductItemDefaultViewModel(product: product)
			self?.resultItemViewModels.append(itemViewModel)
		}
		
		searchFinishedSubject.onNext(())
	}
	
}
