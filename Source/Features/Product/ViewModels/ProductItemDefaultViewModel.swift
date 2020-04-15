//
//  ProductItemDefaultViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxRelay

final class ProductItemDefaultViewModel : ProductItemViewModel {
	
	var productId: BehaviorRelay<String> = BehaviorRelay(value: "")
	var productImageURL: BehaviorRelay<String> = BehaviorRelay(value: "")
	var productPrice: BehaviorRelay<String> = BehaviorRelay(value: "")
	var productLabel: BehaviorRelay<String> = BehaviorRelay(value: "")
	var isFavourite: BehaviorRelay<Bool> = BehaviorRelay(value: false)
	
	init(product: Product) {
		
		productId.accept(product.id)
		productLabel.accept(product.title)
		productImageURL.accept(product.imageUrl)
		productPrice.accept(product.price)
		isFavourite.accept(product.loved > 0)
	}
	
}
