//
//  ProductItemSmallViewCell.swift
//  Sample Ecommerce
//
//  Created by Nanda Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift

final class ProductItemSmallViewCell: UITableViewCell {

	static let cellIdentifier: String = "ProductItemSmallViewCell"
	
	@IBOutlet weak var productImageView: UIImageView!
	@IBOutlet weak var productLabel: UILabel!
	@IBOutlet weak var productPrice: UILabel!
	
	private let disposeBag = DisposeBag()
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
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
		
		viewModel.productPrice
			.asObservable()
			.observeOn(MainScheduler.instance)
			.bind(to: productPrice.rx.text)
			.disposed(by: disposeBag)
	}
    
}
