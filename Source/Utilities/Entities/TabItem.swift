//
//  TabItem.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

struct TabItem<T: Hashable> {
	
	let tag: T
	let title: String
	let image: UIImage?
	
	init(tag: T, title: String, image: UIImage? = nil) {
		self.tag = tag
		self.title = title
		self.image = image
	}
}
