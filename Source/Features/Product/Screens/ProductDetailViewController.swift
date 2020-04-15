//
//  ProductDetailViewController.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift

final class ProductDetailViewController: UIViewController {
	
	@IBOutlet private weak var productImageView: UIImageView!
	@IBOutlet private weak var productLabel: UILabel!
	@IBOutlet private weak var favouriteImageView: UIImageView!
	@IBOutlet private weak var productDescriptionTextView: UITextView!
	@IBOutlet private weak var productPriceLabel: UILabel!
	
	private let disposeBag = DisposeBag()
	
	private let viewModel: ProductDetailViewModel?
	
	init(viewModel: ProductDetailViewModel) {
		
		self.viewModel  = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureNavigationBar()
		
		bindViewModelContent()
		bindViewModelEvents()
	}
	
	private func configureNavigationBar() {
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "Share"),
			style: .plain,
			target: self,
			action: #selector(share)
		)
	}
	
	private func bindViewModelEvents() {
		
		viewModel?.purchaseSuccessObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] in
				self?.showAlert(title: "Success", message: "Purchase successful!")
			})
			.disposed(by: disposeBag)
		
		viewModel?.purchaseFailedObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] _ in
				self?.showAlert(title: "Failed", message: "Purchase failed!")
			})
			.disposed(by: disposeBag)
	}
	
	private func bindViewModelContent() {
		
		viewModel?.productImageURLObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: productImageView.load)
			.disposed(by: disposeBag)
		
		viewModel?.productLabelObservable
			.observeOn(MainScheduler.instance)
			.bind(to: productLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel?.productDescriptionObservable
			.observeOn(MainScheduler.instance)
			.bind(to: productDescriptionTextView.rx.text)
			.disposed(by: disposeBag)
		
		viewModel?.productPriceObservable
			.observeOn(MainScheduler.instance)
			.bind(to: productPriceLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel?.isFavouriteObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (isFavourite: Bool) in
				self?.favouriteImageView.tintColor = isFavourite ? .red : .systemGray
			})
			.disposed(by: disposeBag)
	}
	
	private func showAlert(title: String, message: String) {
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
		
		present(alert, animated: true, completion: nil)
	}
	
	@objc private func share() {
		print("[TEST] Share tapped")
	}
	
	@IBAction private func buy(_ sender: Any) {
		viewModel?.buy()
	}
	
}
