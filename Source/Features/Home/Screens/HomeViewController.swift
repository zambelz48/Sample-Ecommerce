//
//  HomeViewController.swift
//  Sample Ecommerce
//
//  Created by Nanda Julianda Akbar on 14/04/20.
//  Copyright © 2020 Nanda. All rights reserved.
//

import UIKit
import RxSwift

final class HomeViewController : UIViewController {
	
	enum Event {
		case openProductDetailPage(id: String)
		case openFeedPage
		case openCartPage
		case openProfilePage
		case openSearchPage
	}
	
	var navigationEvent: ((HomeViewController.Event) -> ())?
	
	@IBOutlet private weak var tabBar: UITabBar!
	@IBOutlet private weak var tableView: UITableView!
	
	private let searchController = UISearchController(searchResultsController: nil)
	
	private let tabItems: [TabItem<HomeTab>] = [
		TabItem(tag: .Home, title: "Home", image: UIImage(named: "Home")),
		TabItem(tag: .Feed, title: "Feed", image: UIImage(named: "Feed")),
		TabItem(tag: .Cart, title: "Cart", image: UIImage(named: "Cart")),
		TabItem(tag: .Profile, title: "Profile", image: UIImage(named: "User"))
	]
	
	private let disposeBag = DisposeBag()
	private let viewModel: HomeViewModel?
	
	init(viewModel: HomeViewModel) {
		
		self.viewModel = viewModel
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		configureSearchBar()
		configureTabItems()
		configureTableView()
		
		bindViewModel()
		
		viewModel?.fetchData()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let itemHome = tabBar.items?[0] {
			tabBar.selectedItem = itemHome
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if let selectionIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectionIndexPath, animated: animated)
		}
	}
	
	private func configureSearchBar() {
		
		searchController.searchBar.delegate = self
		navigationItem.titleView = searchController.searchBar
	}
	
	private func configureTabItems() {
		tabBar.set(items: tabItems)
	}
	
	private func configureTableView() {
		
		tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 44
		
		tableView.registerCell(identifier: ProductCategoryViewCell.cellIdentifier)
		tableView.registerCell(identifier: ProductItemViewCell.cellIdentifier)
	}
	
	private func reloadTableView() {
		
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
		}
	}
	
	private func bindViewModel() {
		
		viewModel?.fetchDataSuccessObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: reloadTableView)
			.disposed(by: disposeBag)
		
		viewModel?.fetchDataErrorObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { (error: Error) in
				print("[TEST] Error: \(error.localizedDescription)")
			})
			.disposed(by: disposeBag)
	}
	
	private func productCategoryCell(at indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCategoryViewCell.cellIdentifier, for: indexPath) as? ProductCategoryViewCell else {
			return UITableViewCell()
		}
		
		return cell
	}
	
	private func productItemCell(at indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductItemViewCell.cellIdentifier, for: indexPath) as? ProductItemViewCell,
			let productItemsViewModel = viewModel?.productItemViewModel(at: indexPath.row) else {
				return UITableViewCell()
		}
		
		cell.bind(viewModel: productItemsViewModel)
		
		return cell
	}
	
}


// MARK: - UITabBarDelegate

extension HomeViewController : UITabBarDelegate {
	
	func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

		let filteredItem = self.tabItems.filter({ (tabItem: TabItem) -> Bool in
			return item.tag == tabItem.tag.hashValue
		})
		
		guard let tag = filteredItem.first?.tag, tag != .Home else {
			return
		}

		switch tag {

		case .Home:
			break

		case .Feed:
			navigationEvent?(.openFeedPage)

		case .Cart:
			navigationEvent?(.openCartPage)

		case .Profile:
			navigationEvent?(.openProfilePage)

		}

	}
	
}


// MARK: - UITableViewDataSource & UITableViewDelegate

extension HomeViewController : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let section = indexPath.section
		
		switch section {
			
		case 0:
			return 100.0
			
		case 1:
			return 200.0
			
		default:
			return 44.0
			
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		switch section {
		case 0:
			return  1
			
		case 1:
			guard let productCount = viewModel?.productsCount else {
				return 0
			}
			return productCount
			
		default:
			return  0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let section = indexPath.section
		
		switch section {
			
		case 0:
			return productCategoryCell(at: indexPath)
			
		case 1:
			return productItemCell(at: indexPath)
			
		default:
			return UITableViewCell()
			
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard indexPath.section == 0,
			let cell = cell as? ProductCategoryViewCell else  {
				return
		}
		
		cell.configureCollectionView(with: self, forRow: indexPath.row)
	}
	
}

extension HomeViewController : UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let section = indexPath.section
		
		switch section {
			
		case 0:
			print("Category section item tapped")
			
		case 1:
			
			guard let productId = viewModel?.productId(at: indexPath.row) else {
				return
			}
			
			navigationEvent?(.openProductDetailPage(id: productId))
			
		default:
			break
			
		}
		
	}
	
}


// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension HomeViewController : UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		guard let categoryCount = viewModel?.productCategoriesCount else {
			return 0
		}
		
		return categoryCount
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cellIdentifier = ProductCategoryCollViewCell.cellIdentifier
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProductCategoryCollViewCell,
			let categoryItemViewModel = viewModel?.productCategoryViewModel(at: indexPath.row) else {
				return UICollectionViewCell()
		}
		
		cell.bind(viewModel: categoryItemViewModel)
		
		return cell
	}
	
}

extension HomeViewController : UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// TODO: Handle category selection here...
	}
	
}


//  MARK: -  UISearchBarDelegate

extension HomeViewController : UISearchBarDelegate {
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool  {
		
		if (searchController.isActive) {
			searchController.dismiss(animated: false, completion: nil)
		}
		
		navigationEvent?(.openSearchPage)
		
		return false
	}
	
}
