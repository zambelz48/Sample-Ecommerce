//
//  ProductListViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxRelay

protocol ProductListViewModel {
	
	var dataCount: Int { get }
	
	func add(products: [Product])
	
	func itemViewModel(at index: Int) -> ProductItemViewModel
	
}
