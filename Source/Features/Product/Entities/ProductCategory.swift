//
//  ProductCategory.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

struct ProductCategory : Codable, Hashable {
	
	let id: Int
	let imageUrl: String
	let name: String
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
		imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
		name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
}
