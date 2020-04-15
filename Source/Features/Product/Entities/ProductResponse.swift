//
//  ProductResponse.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

struct ProductResponse : Codable, Hashable {
	
	private let uuid: String = UUID().uuidString
	
	let category: [ProductCategory]
	let productPromo: [Product]
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(uuid)
	}
	
}
