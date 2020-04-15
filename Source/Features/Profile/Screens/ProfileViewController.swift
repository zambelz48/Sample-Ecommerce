//
//  ProfileViewController.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift

final class ProfileViewController: UIViewController {
	
	enum Event {
		case openProductDetailPage(id: String)
	}
	
	var navigationEvent: ((ProfileViewController.Event) -> ())?
	
	@IBOutlet private weak var tableView: UITableView!
	
	private let disposeBag = DisposeBag()
	
	private let viewModel: ProfileViewModel?
	
	init(viewModel: ProfileViewModel) {
		
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Purchased History"
		
		configureTableView()
		
		bindViewModel()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if let selectionIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectionIndexPath, animated: animated)
		}
	}
	
	private func configureTableView() {
		tableView.registerCell(identifier: ProductItemSmallViewCell.cellIdentifier)
	}
	
	private func reloadTableView() {
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.beginUpdates()
			self?.tableView.reloadSections(IndexSet(integersIn: 0...0), with: .middle)
			self?.tableView.endUpdates()
		}
	}
	
	private func bindViewModel() {
		
		viewModel?.loadFinishedObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: reloadTableView)
			.disposed(by: disposeBag)
	}
	
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ProfileViewController : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		guard let purchasedCount = viewModel?.purchasedCount else {
			return 0
		}
		
		return purchasedCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductItemSmallViewCell.cellIdentifier, for: indexPath) as? ProductItemSmallViewCell,
			let itemViewModel =  viewModel?.purchasedItem(at: indexPath.row) else {
				return UITableViewCell()
		}
		
		cell.bind(viewModel: itemViewModel)
		
		return cell
	}
	
	
}

extension ProfileViewController : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		guard let productId = viewModel?.productId(at: indexPath.row) else {
			return
		}
		
		navigationEvent?(.openProductDetailPage(id: productId))
	}
	
}
