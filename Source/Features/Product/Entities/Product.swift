//
//  Product.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

struct Product : Codable, Hashable {
	
	let id: String
	let imageUrl: String
	let title: String
	let description: String
	let price: String
	let loved: Int
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
		imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
		title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
		description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
		price = try container.decodeIfPresent(String.self, forKey: .price) ?? ""
		loved = try container.decodeIfPresent(Int.self, forKey: .loved) ?? 0
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
}
