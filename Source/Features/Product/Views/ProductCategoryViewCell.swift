//
//  ProductCategoryViewCell.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 15/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit

final class ProductCategoryViewCell: UITableViewCell {

	static let cellIdentifier: String = "ProductCategoryViewCell"
	
	@IBOutlet private weak var collectionView: UICollectionView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		let cellNib = UINib(nibName: ProductCategoryCollViewCell.cellIdentifier, bundle: nil)
		collectionView.register(cellNib, forCellWithReuseIdentifier: ProductCategoryCollViewCell.cellIdentifier)
    }
	
	func configureCollectionView<Delegate: UICollectionViewDataSource & UICollectionViewDelegate>(
		with delegate: Delegate,
		forRow row: Int
	) {
		
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        collectionView.reloadData()
    }
	
}
