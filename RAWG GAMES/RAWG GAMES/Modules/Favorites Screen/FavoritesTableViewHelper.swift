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
        cell.genreLabel.text = ""
        cell.gameImageView.kf.setImage(with: URL.init(string: favoriteGames[indexPath.row].imageURL ?? ""))
        cell.releasedLabel.text = favoriteGames[indexPath.row].released!.prefix(4).description
        cell.ratingLabel.text = "\(favoriteGames[indexPath.row].rating)/\(favoriteGames[indexPath.row].ratingTop)"
        cell.backgroundColor = .systemGray6
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
}
