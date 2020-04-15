//
//  HttpRequestSpec.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation

enum HttpMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

struct HttpRequestSpec {
	
	let method: HttpMethod
	let url: String
	
	private(set) var headers: [String : String] = [String : String]()
	private(set) var parameters: [String : Any] = [String : Any]()
	
	init(url: String, method: HttpMethod = .get) {
		self.url = url
		self.method = method
	}
	
	mutating func appendHeader(key: String, value: String) {
		headers.updateValue(value, forKey: key)
	}
	
	mutating func appendParameters(key: String, value: Any) {
		parameters.updateValue(value, forKey: key)
	}
	
}
