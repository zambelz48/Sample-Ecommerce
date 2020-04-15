//
//  ProductCategoryCollViewCell.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift

final class ProductCategoryCollViewCell: UICollectionViewCell {
	
	static let cellIdentifier: String = "ProductCategoryCollViewCell"
	
	@IBOutlet private weak var categoryImageView: UIImageView!
	@IBOutlet private weak var categoryLabel: UILabel!
	
	private let disposeBag = DisposeBag()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
	
	func bind(viewModel: ProductCategoryItemViewModel) {
		
		viewModel.imageURL.asObservable()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: categoryImageView.load(from:))
			.disposed(by: disposeBag)
		
		viewModel.label.asObservable()
			.observeOn(MainScheduler.instance)
			.bind(to: categoryLabel.rx.text)
			.disposed(by: disposeBag)
	}
	
}
