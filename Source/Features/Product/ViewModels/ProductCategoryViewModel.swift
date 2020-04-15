//
//  ProductCategoryViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxRelay

protocol ProductCategoryViewModel {
	
	var dataCount: Int { get }
	
	func add(categories: [ProductCategory])
	
	func itemViewModel(at index: Int) -> ProductCategoryItemViewModel
	
}
