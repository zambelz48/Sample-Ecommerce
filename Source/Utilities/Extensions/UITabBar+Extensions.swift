//
//  UITabBar+Extensions.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

extension UITabBar {
	
	func set<T: Hashable>(items: [TabItem<T>], animated: Bool = false) {
		
		let tabItems = items.map { (item: TabItem) -> UITabBarItem in
			return UITabBarItem(
				title: item.title,
				image: item.image,
				tag: item.tag.hashValue
			)
		}
		
		self.setItems(tabItems, animated: animated)
	}
	
}
