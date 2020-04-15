//
//  ProductCategoryItemDefaultViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxRelay

final class ProductCategoryItemDefaultViewModel : ProductCategoryItemViewModel {
	
	var imageURL: BehaviorRelay<String> = BehaviorRelay(value: "")
	var label: BehaviorRelay<String> = BehaviorRelay(value: "")
	
	init(category: ProductCategory) {
		imageURL.accept(category.imageUrl)
		label.accept(category.name)
	}
	
}
