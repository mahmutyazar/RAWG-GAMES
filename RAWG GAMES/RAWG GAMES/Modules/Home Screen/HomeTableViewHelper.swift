//
//  HomeTableViewHelper.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit
import Alamofire
import Lottie

class HomeTableViewHelper: NSObject {
    
    typealias RowItem = HomeCellModel
    typealias SearchItem = [HomeCellModel]
    
    private let model = HomeModel()
    
    private let cellIdentifier = "HomeTableViewCell"
    private var tableView: UITableView?
    private var searchBar: UISearchBar?
    private var navigationController: UINavigationController?
    private weak var viewModel: HomeViewModel?
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    private var items: [RowItem] = []
    private var searchResults: SearchItem
    
    private var nextPageURL : String?
    
    init(tableView: UITableView, viewModel: HomeViewModel, searchBar: UISearchBar, searchResults: SearchItem, navigationController: UINavigationController) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.searchBar = searchBar
        self.searchResults = searchResults
        self.navigationController = navigationController
        
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView?.separatorStyle = .none
        tableView?.register(.init(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.dataSource = self
        tableView?.delegate = self
        searchBar?.delegate = self
        tableView?.keyboardDismissMode = .onDrag
    }
    
    func setItems(_ items: [RowItem]) {
        self.items = items
        self.searchResults = items
        tableView?.reloadData()
    }
}

extension HomeTableViewHelper: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if InternetManager.shared.isInternetActive() {
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let detailsVC = storyBoard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else {
                return
            }
            let id = searchResults[indexPath.row].id
            detailsVC.getID(id)
            detailsVC.title = searchResults[indexPath.row].name
            
            navigationController?.pushViewController(detailsVC, animated: true)
        } else {
            viewModel?.errorCaught!("You can not see the details of games when you're offline. Please connect to internet.".localized())
        }
        
    }
}

extension HomeTableViewHelper: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if InternetManager.shared.isInternetActive() {
            return searchResults.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HomeTableViewCell
        
        if InternetManager.shared.isInternetActive() {
            cell.configure(with: searchResults[indexPath.row])
        } else {
            cell.configure(with: items[indexPath.row])
        }
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 15
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 8, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
}


//MARK: -Service search.

extension HomeTableViewHelper: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            if let searchText = searchBar.text {
                
                AF.request("\(Constants.sharedURL)?key=\(Constants.apiKey)&search=\(searchText)&page_size=30").responseDecodable(of: ApiGame.self) { search in
                    
                    guard let response = search.value else {
                        print("no data")
                        return
                    }
                    let results = response.results ?? []
                    let homeCellModel: [HomeCellModel] = results.map {.init(id: $0.id ?? 0, name: $0.name ?? "", backgroundImage: $0.backgroundImage ?? "", released: $0.released ?? "", rating: $0.rating ?? 0.0, ratingTop: $0.ratingTop ?? 0)}
                    
                    self!.searchResults = homeCellModel
                    self!.tableView?.reloadData()
                }
            }
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: requestWorkItem)
    }
}

//MARK: -  WARNING! This extension belong to HomeViewController, does not belong to HomeTableViewHelper that you're currently in.

extension HomeViewController {
    
    func sortTable() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            items.sort(by: {$0.name < $1.name})
            tableViewHelper.setItems(items)
        case 1:
            items.sort(by: {$0.rating > $1.rating })
            tableViewHelper.setItems(items)
        default:
            print("error")
        }
        DispatchQueue.main.async {
            self.homeTableView.reloadData()
        }
    }
    
    func setupUI() {
        tableViewHelper = .init(tableView: (homeTableView), viewModel: viewModel, searchBar: searchBar, searchResults: searchResults, navigationController: navigationController!)
    }
    
    func setupBindings() {
        
        viewModel.errorCaught = {[weak self] alert in
            let alert = UIAlertController(title: "ALERT".localized(), message: alert, preferredStyle: .alert)
            alert.addAction(.init(title: "OK".localized(), style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.loadItems = {[weak self] items in
            self?.tableViewHelper.setItems(items)
            self!.animationView.stop()
            self!.animationView.isHidden = true
            self!.items = items
        }
    }
    
    func setupAnimation() {
        animationView.animation = LottieAnimation.named("gaming")
        animationView.frame = view.bounds
        animationView.backgroundColor = .systemBackground
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
}
