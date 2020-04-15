//
//  UITableView+Extensions.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

extension UITableView  {
	
	func registerCell(identifier: String) {
		
		let cellNib = UINib(nibName: identifier, bundle: nil)
		
		self.register(cellNib, forCellReuseIdentifier: identifier)
	}
	
}
