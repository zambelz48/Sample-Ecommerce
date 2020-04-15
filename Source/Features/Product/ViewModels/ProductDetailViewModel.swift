//
//  ProductDetailViewModel.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

protocol ProductDetailViewModel {
	
	var purchaseSuccessObservable: Observable<Void> { get }
	var purchaseFailedObservable: Observable<Error> { get }
	
	var productImageURLObservable: Observable<String> { get }
	var productLabelObservable: Observable<String> { get }
	var isFavouriteObservable: Observable<Bool> { get }
	var productDescriptionObservable: Observable<String> { get }
	var productPriceObservable: Observable<String> { get }
	
	func load()
	
	func buy()
	
}
