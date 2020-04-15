//
//  HomeViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModel {
	
	var productCategoriesCount: Int { get }
	
	var productsCount: Int { get }
	
	var fetchDataSuccessObservable: Observable<Void> { get }
	
	var fetchDataErrorObservable: Observable<Error> { get }
	
	func fetchData()
	
	func productItemViewModel(at index: Int) -> ProductItemViewModel
	
	func productCategoryViewModel(at index: Int) -> ProductCategoryItemViewModel
	
	func productId(at index: Int) -> String
	
}
