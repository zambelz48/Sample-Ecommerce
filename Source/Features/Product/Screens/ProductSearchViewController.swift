//
//  ProductSearchViewController.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift

final class ProductSearchViewController: UIViewController {

	enum Event {
		case openProductDetailPage(id: String)
	}
	
	var navigationEvent: ((ProductSearchViewController.Event) -> ())?
	
	@IBOutlet private weak var tableView: UITableView!

	private let searchController = UISearchController(searchResultsController: nil)
	
	private let disposeBag = DisposeBag()
	
	private let viewModel: ProductSearchViewModel?
	
	init(viewModel: ProductSearchViewModel) {
		
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSearchBar()
		configureTableView()
		
		bindViewModel()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		DispatchQueue.main.async { [weak self] in
			
			guard let self = self else {
				return
			}
			
			if (!self.searchController.isActive) {
				self.searchController.searchBar.becomeFirstResponder()
				self.searchController.isActive = true
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if let selectionIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectionIndexPath, animated: animated)
		}
		
		if (searchController.isActive) {
			searchController.dismiss(animated: false, completion: nil)
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
	
	private func configureSearchBar() {
		
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
		
		navigationItem.titleView = searchController.searchBar
	}
	
	private func bindViewModel() {
		
		viewModel?.searchFinishedObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: reloadTableView)
			.disposed(by: disposeBag)
	}

}


// MARK: - UITableViewDataSource & UITableViewDelegate

extension ProductSearchViewController : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		guard let resultCount = viewModel?.resultCount else {
			return 0
		}
		
		return resultCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductItemSmallViewCell.cellIdentifier, for: indexPath) as? ProductItemSmallViewCell,
			let itemViewModel =  viewModel?.resultItem(at: indexPath.row) else {
				return UITableViewCell()
		}
		
		cell.bind(viewModel: itemViewModel)
		
		return cell
	}
	
}

extension ProductSearchViewController : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		guard let productId = viewModel?.productId(at: indexPath.row) else {
			return
		}
		
		navigationEvent?(.openProductDetailPage(id: productId))
	}
	
}


// MARK: - UISearchResultsUpdating

extension ProductSearchViewController : UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		
		guard let searchText = searchController.searchBar.text else {
			return
		}
		
		if (searchText.count >= 3 && !searchController.isBeingDismissed) {
			viewModel?.search(keyword: searchText)
		}
	}
	
}
