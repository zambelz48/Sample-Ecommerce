//
//  ProductEndpoint.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

enum ProductEndpoint : String {
	
	case list
	
	var rawValue: String {
		
		switch self {
			
		case .list:
			return "\(Config.baseApiURL)/home"
			
		}
	}
	
}
