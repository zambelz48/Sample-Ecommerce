//
//  AppDelegate.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	private var rootRoutes: RootRoutes?
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		
		window = UIWindow()
		window?.rootViewController = rootViewController()
		window?.makeKeyAndVisible()
		
		return true
	}
	
	private func rootViewController() -> UINavigationController? {
		
		rootRoutes = RootRoutes(navigationController: UINavigationController())
		
		return rootRoutes?.navigationController
	}

}
