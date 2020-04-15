//
//  ProductRepository.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductRepository {
	
	func getData() -> Observable<ProductResponse>
	
	func getProduct(id: String) -> Observable<Product>
	
	func search(keyword: String) -> Observable<[Product]>
	
}
