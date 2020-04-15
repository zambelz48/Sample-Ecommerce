//
//  UIImageView+Extension.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	
	func load(from urlString: String) {
		
		let loadingView = UIActivityIndicatorView(style: .whiteLarge)
		loadingView.startAnimating()
		
		addSubview(loadingView)
		
		loadingView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
			loadingView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		
		let httpHandler = HttpHandler()
		let spec = HttpRequestSpec(url: urlString)
		
		httpHandler.request(
			spec: spec,
			onSuccess: { (data: Data?) in
				
				guard let data = data else {
					return
				}
				
				DispatchQueue.main.async { [weak self] in
					
					loadingView.removeFromSuperview()
					
					self?.contentMode = .scaleToFill
					self?.image = UIImage(data: data)
				}
			},
			onFailed: { (error: Error) in
				DispatchQueue.main.async {
					loadingView.removeFromSuperview()
				}
			}
		)
	}
	
}
