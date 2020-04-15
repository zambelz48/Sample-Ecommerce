//
//  ProductItemViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxRelay

protocol ProductItemViewModel {
	
	var productId: BehaviorRelay<String> { get }
	
	var productImageURL: BehaviorRelay<String> { get }
	
	var productPrice: BehaviorRelay<String> { get }
	
	var productLabel: BehaviorRelay<String> { get }
	
	var isFavourite: BehaviorRelay<Bool> { get }
	
}
