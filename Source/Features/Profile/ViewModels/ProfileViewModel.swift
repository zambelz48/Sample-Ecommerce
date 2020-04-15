//
//  ProfileViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileViewModel {
	
	var loadFinishedObservable: Observable<Void> { get }
	
	var purchasedCount: Int { get }
	
	func load()
	
	func purchasedItem(at index: Int) -> ProductItemViewModel
	
	func productId(at index: Int) -> String
	
}
