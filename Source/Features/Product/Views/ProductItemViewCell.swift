//
//  ProductItemViewCell.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductItemViewCell: UITableViewCell {

	static let cellIdentifier: String = "ProductItemViewCell"
	
	@IBOutlet private weak var productImageView: UIImageView!
	@IBOutlet private weak var favouriteImageView: UIImageView!
	@IBOutlet private weak var productLabel: UILabel!
	
	private let disposeBag = DisposeBag()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		productImageView.layer.borderColor = UIColor.gray.cgColor
		productImageView.layer.borderWidth = 0.5
	}
	
	func bind(viewModel: ProductItemViewModel) {
		
		viewModel.productLabel
			.asObservable()
			.observeOn(MainScheduler.instance)
			.bind(to: productLabel.rx.text)
			.disposed(by: disposeBag)
		
		viewModel.productImageURL
			.asObservable()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: productImageView.load)
			.disposed(by: disposeBag)
		
		viewModel.isFavourite
			.asObservable()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (isFavourite: Bool) in
				self?.favouriteImageView.tintColor = isFavourite ? .red : .systemGray
			})
			.disposed(by: disposeBag)
	}
    
}
