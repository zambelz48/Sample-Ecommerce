//
//  RootRoutes.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class RootRoutes {
	
	let navigationController: UINavigationController
	
	private let authRoutes: AuthRoutes?
	private let mainRoutes: MainRoutes?
	
	private let isUserAuthenticated: Bool = false
	
	init(navigationController: UINavigationController) {
		
		self.navigationController =  navigationController
		
		authRoutes = AuthRoutes(navigationController: navigationController)
		mainRoutes = MainRoutes(navigationController: navigationController)
		
		configureRoutes()
	}
	
	private func configureRoutes() {
		
		if (isUserAuthenticated) {
			mainRoutes?.initialize()
		} else {
			authRoutes?.initialize()
			configureAuthRoutesEvent()
		}
	}
	
	private func configureAuthRoutesEvent() {
		
		authRoutes?.routeEvent = { [weak self] (event: AuthRoutes.Event) in
			
			switch event {
				
			case .signIn:
				self?.mainRoutes?.initialize()
				
			}
			
		}
	}
	
}
