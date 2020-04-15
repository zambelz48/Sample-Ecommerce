//
//  HomeTab.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

enum HomeTab : String, Hashable {
	
	case Home
	case Feed
	case Cart
	case Profile
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.rawValue)
	}
}
