//
//  HomeTableViewHelper.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit

class HomeTableViewHelper: NSObject {
    
    typealias RowItem = HomeCellModel
    private let cellIdentifier = "HomeTableViewCell"
    private var tableView: UITableView?
    private weak var viewModel: HomeViewModel?
    private var items: [RowItem] = []
 
    
    init(tableView: UITableView, viewModel: HomeViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView?.separatorStyle = .none
        tableView?.register(.init(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
//        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    func setItems(_ items: [RowItem]) {
        self.items = items
        tableView?.reloadData()
    }
}

//extension HomeTableViewHelper: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel?.itemPressed(indexPath.row)
//
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        guard let charDetailVC = mainStoryBoard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else {
//            return
//        }
//
//        vcHome.navigationController?.pushViewController(charDetailVC, animated: true)
//
//    }
//}


extension HomeTableViewHelper: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HomeTableViewCell
        cell.configure(with: items[indexPath.row])
        cell.backgroundColor = .systemGray6
        return cell
    }
}
