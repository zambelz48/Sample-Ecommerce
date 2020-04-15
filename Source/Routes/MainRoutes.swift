//
//  HomeRoutes.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class MainRoutes {
	
	private let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		
		self.navigationController =  navigationController
		
	}
	
	func initialize() {
		
		let homeViewController = createHomeViewController()
		self.navigationController.setViewControllers([homeViewController], animated: true)
	}
	
	private func createHomeViewController() -> UIViewController {
		
		let httpHandler = HttpHandler()
		let repository = ProductDefaultRepository(httpHandler: httpHandler)
		let homeViewModel = HomeDefaultViewModel(productRepository: repository)
		let viewController = HomeViewController(viewModel: homeViewModel)
		
		viewController.navigationEvent = { [weak self] (event: HomeViewController.Event) in
			
			guard let self = self else {
				return
			}
			
			switch event {
				
			case .openFeedPage:
				let feedViewController = self.createFeedViewController()
				self.navigationController.pushViewController(feedViewController, animated: true)
				
			case .openCartPage:
				let cartViewController = self.createCartViewController()
				self.navigationController.pushViewController(cartViewController, animated: true)
				
			case .openProfilePage:
				let profileViewController = self.createProfileViewController()
				self.navigationController.pushViewController(profileViewController, animated: true)
				
			case .openProductDetailPage(let id):
				let productDetailViewController = self.createProductDetailViewController(id: id)
				self.navigationController.pushViewController(productDetailViewController, animated: true)
				
			case .openSearchPage:
				let searchViewController = self.createSearchViewController()
				self.navigationController.pushViewController(searchViewController, animated: true)
				
			}
		}
		
		return viewController
	}
	
	private func createFeedViewController() -> UIViewController {
		return FeedViewController()
	}
	
	private func createCartViewController() -> UIViewController {
		return CartViewController()
	}
	
	private func createProfileViewController() -> UIViewController {
		
		let orderRepository = OrderDefaultRepository()
		let profileViewModel = ProfileDefaultViewModel(orderRepository: orderRepository)
		let viewController = ProfileViewController(viewModel: profileViewModel)
		
		viewController.navigationEvent = { [weak self] (event: ProfileViewController.Event) in
			
			guard let self = self else {
				return
			}
			
			switch event {
				
			case .openProductDetailPage(let id):
				let productDetailViewController = self.createProductDetailViewController(id: id)
				self.navigationController.pushViewController(productDetailViewController, animated: true)
				
			}
			
		}
		
		return viewController
	}
	
	private func createProductDetailViewController(id: String) -> UIViewController {
		
		let httpHandler = HttpHandler()
		let productRepository = ProductDefaultRepository(httpHandler: httpHandler)
		let orderRepository = OrderDefaultRepository()
		let detailViewModel = ProductDetailDefaultViewModel(
			productId: id,
			productRepository: productRepository,
			orderRepository: orderRepository
		)
		
		return ProductDetailViewController(viewModel: detailViewModel)
	}
	
	private func createSearchViewController() -> UIViewController {
		
		let httpHandler = HttpHandler()
		let productRepository = ProductDefaultRepository(httpHandler: httpHandler)
		let productSearchViewModel = ProductSearchDefaultViewModel(productRepository: productRepository)
		let viewController = ProductSearchViewController(viewModel: productSearchViewModel)
		
		viewController.navigationEvent = { [weak self] (event: ProductSearchViewController.Event) in
			
			guard let self = self else {
				return
			}
			
			switch event {
				
			case .openProductDetailPage(let id):
				let productDetailViewController = self.createProductDetailViewController(id: id)
				self.navigationController.pushViewController(productDetailViewController, animated: true)
				
			}
		}
		
		return viewController
	}
	
}
