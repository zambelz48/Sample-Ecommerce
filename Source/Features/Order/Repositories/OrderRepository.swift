//
//  OrderRepository.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol OrderRepository {
	
	func save(order: Product) -> Observable<Void>
	
	func getList() -> Observable<[Product]>
	
}
