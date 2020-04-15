//
//  ProductListDefaultViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class ProductListDefaultViewModel : ProductListViewModel {
	
	var dataCount: Int {
		return itemViewModels.count
	}
	
	private var itemViewModels: [ProductItemViewModel] = [ProductItemViewModel]()
	
	private let disposeBag = DisposeBag()
	private let productItemsRelay: BehaviorRelay<[Product]> = BehaviorRelay(value: [Product]())
	
	init() {
		
		productItemsRelay.asObservable()
			.flatMap({ (products: [Product]) -> Observable<ProductItemViewModel> in
				return Observable.from(products)
					.map ({ (product: Product) -> ProductItemViewModel in
						return ProductItemDefaultViewModel(product: product)
					})
			})
			.subscribe(onNext: append(itemViewModel:))
			.disposed(by: disposeBag)
	}
	
	func add(products: [Product]) {
		productItemsRelay.accept(products)
	}
	
	func itemViewModel(at index: Int) -> ProductItemViewModel {
		return itemViewModels[index]
	}
	
	private func append(itemViewModel: ProductItemViewModel) {
		itemViewModels.append(itemViewModel)
	}
}
