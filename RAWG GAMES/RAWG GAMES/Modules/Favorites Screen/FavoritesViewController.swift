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
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    private var tableViewHelper: FavoriteTableViewHelper!
    private let viewModel = FavoritesViewModel()
    var favoriteGames: [FavoriteGame] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites".localized()
        infoLabel.text = "Favorites list is empty.".localized()
        
        setupBindings()
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel.didViewLoad()
        favoritesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if favoriteGames.count > 0 {
            self.favoritesView.isHidden = true
        } else {
            self.favoritesView.isHidden = false
        }
    }
    
    func setupUI() {
        
        tableViewHelper = .init(tableView: favoritesTableView, navigationController: navigationController!)
    }
    
    func setupBindings() {
        viewModel.errorCaught = {[weak self] alert in
            let alert = UIAlertController(title: "ALERT".localized(), message: alert, preferredStyle: .alert)
            alert.addAction(.init(title: "OK".localized(), style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.loadItems = { [weak self] favorites in
            self?.tableViewHelper.setItems(with: favorites)
            self?.favoriteGames = favorites
        }
    }
    
    @IBAction func cleanButton(_ sender: Any) {
        let alert = UIAlertController(title: "WARNING".localized(), message: "Are you sure to delete all favorites?".localized(), preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "DELETE".localized(), style: UIAlertAction.Style.default) { [self] UIAlertAction in
            do {
                tableViewHelper.deleteAllRecords(entity: "FavoriteGame")
                self.favoriteGames.removeAll()
                self.favoritesTableView?.reloadData()
                favoritesView.isHidden = false
            } catch {
                print("could not delete")
            }
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: UIAlertAction.Style.cancel) {
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
