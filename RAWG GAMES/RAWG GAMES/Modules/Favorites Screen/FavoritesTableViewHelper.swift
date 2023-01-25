//
//  FavoritesTableViewHelper.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 20.01.2023.
//

import UIKit
import CoreData

class FavoriteTableViewHelper: NSObject {
    
    private var navigationController: UINavigationController?
    private let cellIdentifier = "HomeTableViewCell"
    private var favoriteGames: [FavoriteGame] = []
    private let viewModel = FavoritesViewModel()
    private var tableView: UITableView?
    
    init(tableView: UITableView, navigationController: UINavigationController) {
        self.tableView = tableView
        self.navigationController = navigationController
        super.init()
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView?.separatorStyle = .none
        tableView?.register(.init(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.keyboardDismissMode = .onDrag
    }
    
    func setItems(with items: [FavoriteGame]) {
        
        self.favoriteGames = items
        tableView?.reloadData()
    }
    
    func deleteAllRecords(entity : String) {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try Constants.context.execute(deleteRequest)
            try Constants.context.save()
            self.favoriteGames.removeAll()
            self.tableView?.reloadData()
        } catch {
            print ("There was an error")
        }
    }
}

extension FavoriteTableViewHelper: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailsVC = storyBoard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else {
            return
        }
        
        let id = favoriteGames[indexPath.row].id
        detailsVC.getID(Int(id))
        detailsVC.title = favoriteGames[indexPath.row].name
        detailsVC.isFavorite = true
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension FavoriteTableViewHelper: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        cell.gameNameLabel.text = favoriteGames[indexPath.row].name ?? ""
        cell.gameImageView.kf.setImage(with: URL.init(string: favoriteGames[indexPath.row].imageURL ?? ""))
        cell.releasedLabel.text = favoriteGames[indexPath.row].released!.prefix(4).description
        cell.ratingLabel.text = "\(favoriteGames[indexPath.row].rating)/\(favoriteGames[indexPath.row].ratingTop)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = favoriteGames[indexPath.row]
            Constants.context.delete(commit)
            favoriteGames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try Constants.context.save()
            } catch {
                print("could not delete")
            }
        }
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

//MARK: -  WARNING! This extension belong to FavoritesViewController, does not belong to FavoriteTableViewHelper that you're currently in.

extension FavoritesViewController {
    
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
        
        tableViewHelper = .init(tableView: favoritesTableView,
                                navigationController: navigationController!)
    }
    
    func setupBindings() {
        viewModel.errorCaught = {[weak self] alert in
            let alert = UIAlertController(title: "ALERT".localized(),
                                          message: alert, preferredStyle: .alert)
            
            alert.addAction(.init(title: "OK".localized(),
                                  
                                  style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.loadItems = { [weak self] favorites in
            self?.tableViewHelper.setItems(with: favorites)
            self?.favoriteGames = favorites
        }
    }
    
    
    func cleanFavorites() {
        
        let alert = UIAlertController(title: "WARNING".localized(),
                                      message: "Are you sure to delete all favorites?".localized(),
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "DELETE".localized(),
                                     style: UIAlertAction.Style.default) { [self] UIAlertAction in
            do {
                tableViewHelper.deleteAllRecords(entity: "FavoriteGame")
                self.favoriteGames.removeAll()
                self.favoritesTableView?.reloadData()
                favoritesView.isHidden = false
            } catch {
                print("could not delete")
            }
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL".localized(),
                                         style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}
