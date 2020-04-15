//
//  LoginViewController.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

	enum Event {
		case signIn
	}
	
	var navigationEvent: ((LoginViewController.Event) -> ())?
	
	@IBOutlet private weak var containerView: UIView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		containerView.layer.borderColor = UIColor.gray.cgColor
		containerView.layer.borderWidth = 0.5
    }

	@IBAction private func signIn(_ sender: Any) {
		navigationEvent?(.signIn)
	}
	
	@IBAction func signInWithFacebook(_ sender: Any) {
		navigationEvent?(.signIn)
	}
	
	@IBAction func signInWithGoogle(_ sender: Any) {
		navigationEvent?(.signIn)
	}
	
}
