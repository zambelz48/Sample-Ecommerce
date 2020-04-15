//
//  ProductSearchItemViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductSearchViewModel {
	
	var searchFinishedObservable: Observable<Void> { get }
	
	var resultCount: Int { get }
	
	func search(keyword: String)
	
	func resultItem(at index: Int) -> ProductItemViewModel
	
	func productId(at index: Int) -> String
	
}
