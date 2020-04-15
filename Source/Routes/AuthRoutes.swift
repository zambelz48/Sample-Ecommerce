//
//  AuthRoutes.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class AuthRoutes {
	
	enum Event {
		case signIn
	}
	
	var routeEvent: ((AuthRoutes.Event) -> ())?
	
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		
		self.navigationController =  navigationController
		
	}
	
	func initialize() {
		
		let loginViewController = createLoginViewController()
		navigationController.setViewControllers([loginViewController], animated: true)
	}
	
	private func createLoginViewController() -> UIViewController {
		
		let viewController = LoginViewController()
		
		viewController.navigationEvent = { [weak self] (event: LoginViewController.Event) in
			
			switch event {
				
			case .signIn:
				self?.routeEvent?(.signIn)
				
			}
			
		}
		
		return viewController
	}
	
}
