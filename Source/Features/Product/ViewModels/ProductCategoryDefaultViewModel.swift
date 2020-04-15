
//
//  ProductCategoryDefaultViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class ProductCategoryDefaultViewModel : ProductCategoryViewModel {
	
	var dataCount: Int {
		return itemViewModels.count
	}
	
	private var itemViewModels: [ProductCategoryItemViewModel] = [ProductCategoryItemViewModel]()
	
	private let disposeBag = DisposeBag()
	private let categoryItemsRelay: BehaviorRelay<[ProductCategory]> = BehaviorRelay(value: [ProductCategory]())
	
	init() {
		
		categoryItemsRelay.asObservable()
			.flatMap({ (categories: [ProductCategory]) -> Observable<ProductCategoryItemViewModel> in
				return Observable.from(categories)
					.map ({ (category: ProductCategory) -> ProductCategoryItemViewModel in
						return ProductCategoryItemDefaultViewModel(category: category)
					})
			})
			.subscribe(onNext: append(itemViewModel:))
			.disposed(by: disposeBag)
	}
	
	func add(categories: [ProductCategory]) {
		categoryItemsRelay.accept(categories)
	}
	
	func itemViewModel(at index: Int) -> ProductCategoryItemViewModel {
		return itemViewModels[index]
	}
	
	private func append(itemViewModel: ProductCategoryItemViewModel) {
		itemViewModels.append(itemViewModel)
	}
	
}
