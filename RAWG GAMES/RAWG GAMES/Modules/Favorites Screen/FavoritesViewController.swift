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
    
    var tableViewHelper: FavoriteTableViewHelper!
    let viewModel = FavoritesViewModel()
    var favoriteGames: [FavoriteGame] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites".localized()
        infoLabel.text = "Favorites list is empty.".localized()
        
        setupBindings()
        setupUI()
    }
    
    @IBAction func cleanButton(_ sender: Any) {
        cleanFavorites()
    }
}

extension FavoritesViewController: FavoritesViewModelProtocol {
    func sendData(data: [FavoriteGame]) {
        self.favoriteGames = data
    }
}
