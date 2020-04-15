//
//  OrderDefaultRepository.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 16/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import RxSwift

final class OrderDefaultRepository : OrderRepository {
	
	private let ordersLocalKey = "PurchasedItems"
	private let localStorage = SimpleLocalStorage.shared
	
	
	// MARK: - OrderRepository
	
	func save(order: Product) -> Observable<Void> {
		
		guard localStorage.isDataExists(ordersLocalKey) else {
			return createNew(order: order)
		}
		
		return append(order: order)
	}
	
	func getList() -> Observable<[Product]> {
		
		return Observable.create { [weak self] observer -> Disposable in
			
			let disposable = Disposables.create()
			guard let self = self else {
				observer.onError(ErrorFactory.unknown)
				return disposable
			}
			
			self.localStorage.list(
				key: self.ordersLocalKey,
				onSuccess: { (existingOrders: [Product]) in
					observer.onNext(existingOrders)
					observer.onCompleted()
				},
				onFailed: { (error: Error) in
					observer.onError(error)
					observer.onCompleted()
				}
			)
			
			return disposable
		}
	}
	
	
	// MARK: - Private methods
	
	private func createNew(order: Product) -> Observable<Void> {
		
		return Observable.create { [weak self] observer -> Disposable in
			
			let disposable = Disposables.create()
			guard let self = self else {
				observer.onError(ErrorFactory.unknown)
				return disposable
			}
			
			var newOrders = [Product]()
			newOrders.append(order)
			
			self.localStorage.save(
				key: self.ordersLocalKey,
				data: newOrders,
				onSuccess: { _ in
					observer.onNext(())
					observer.onCompleted()
				},
				onFailed: { (error: Error) in
					observer.onError(error)
					observer.onCompleted()
				}
			)
			
			return disposable
		}
	}
	
	private func append(order: Product) -> Observable<Void> {
		
		return Observable.create { [weak self] observer -> Disposable in
			
			let disposable = Disposables.create()
			guard let self = self else {
				observer.onError(ErrorFactory.unknown)
				return disposable
			}
			
			self.localStorage.list(
				key: self.ordersLocalKey,
				onSuccess: { (orders: [Product]) in
					
					var newOrders = orders
					newOrders.append(order)
					
					self.localStorage.save(
						key: self.ordersLocalKey,
						data: newOrders,
						onSuccess: { _ in
							observer.onNext(())
							observer.onCompleted()
						},
						onFailed: { (error: Error) in
							observer.onError(error)
							observer.onCompleted()
						}
					)
				},
				onFailed: { (error: Error) in
					observer.onError(error)
					observer.onCompleted()
				}
			)
			
			return disposable
		}
	}
	
}
