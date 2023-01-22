//
//  FavoritesViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit
import CoreData
import Kingfisher

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private var tableViewHelper: FavoriteTableViewHelper!
    private let viewModel = FavoritesViewModel()
    var favoriteGames: [FavoriteGame] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        viewModel.didViewLoad()
        favoritesTableView.reloadData()
    }
    
    func setupUI() {
        tableViewHelper = .init(tableView: favoritesTableView, navigationController: navigationController!)
    }
    
    func setupBindings() {
        viewModel.errorCaught = {[weak self] alert in
            let alert = UIAlertController(title: "ALERT", message: alert, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.loadItems = { [weak self] favorites in
            self?.tableViewHelper.setItems(with: favorites)
            self?.favoriteGames = favorites
        }
    }
    
    @IBAction func cleanButton(_ sender: Any) {
        let alert = UIAlertController(title: "WARNING", message: "Are you sure to delete all favorites?", preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "DELETE", style: UIAlertAction.Style.default) { [self] UIAlertAction in
            do {
                tableViewHelper.deleteAllRecords(entity: "FavoriteGame")
            } catch {
                print("could not delete")
            }
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

extension FavoritesViewController: FavoritesViewModelProtocol {
    func sendData(data: [FavoriteGame]) {
        self.favoriteGames = data
    }
}
