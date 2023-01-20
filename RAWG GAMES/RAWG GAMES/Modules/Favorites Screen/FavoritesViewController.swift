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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let cellIdentifier = "HomeTableViewCell"
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    let detaiVC = DetailViewController()
    var favoriteGames: [FavoriteGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveFavoritesFromCoreData()
        favoritesTableView.reloadData()
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
    
    
    
    private func setupTableView() {
        favoritesTableView?.separatorStyle = .none
        favoritesTableView?.register(.init(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier )
        favoritesTableView?.delegate = self
        favoritesTableView?.dataSource = self
    }
    
    private func retrieveFavoritesFromCoreData() {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
        
        do {
            let result = try context.fetch(request)
            self.favoriteGames = result
        } catch {
            print("Data could not retrieve from CoreData")
        }
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
    
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HomeTableViewCell
        cell.gameNameLabel.text = favoriteGames[indexPath.row].name ?? ""
        cell.genreLabel.text = ""
        cell.gameImageView.kf.setImage(with: URL.init(string: favoriteGames[indexPath.row].imageURL ?? ""))
        cell.releasedLabel.text = favoriteGames[indexPath.row].released!.prefix(4).description
        cell.ratingLabel.text = "\(favoriteGames[indexPath.row].rating)/\(favoriteGames[indexPath.row].ratingTop)"
        cell.backgroundColor = .systemGray6
        return cell
    }
}
