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
    
    private let viewModel = FavoritesViewModel()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var favoriteGames: [FavoriteGame] = []
    
    private var tableViewHelper: FavoriteTableViewHelper!
    
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
        tableViewHelper = .init(tableView: favoritesTableView)
        favoritesTableView.delegate = self
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
                deleteAllRecords(entity: "FavoriteGame")
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
        self.favoritesTableView.reloadData()
    }
    
    func deleteAllRecords(entity : String) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            
        do {
                try managedContext.execute(deleteRequest)
                try managedContext.save()
                self.favoritesTableView.reloadData()
            } catch {
                print ("There was an error")
            }
        }
}

extension FavoritesViewController: UITableViewDelegate {
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

extension FavoritesViewController: FavoritesViewModelProtocol {
    func sendData(data: [FavoriteGame]) {
        self.favoriteGames = data
    }
}
