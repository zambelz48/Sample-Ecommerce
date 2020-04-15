//
//  ProductCategoryItemViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxRelay

protocol ProductCategoryItemViewModel {
	
	var imageURL: BehaviorRelay<String> { get }
	
	var label: BehaviorRelay<String> { get }
	
}
