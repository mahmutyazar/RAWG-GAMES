//
//  FavoritesTableViewHelper.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 20.01.2023.
//

import UIKit
import CoreData

class FavoriteTableViewHelper: NSObject {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let cellIdentifier = "HomeTableViewCell"
    
    private var tableView: UITableView?
    private var favoriteGames: [FavoriteGame] = []
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        retrieveFavoritesFromCoreData()
        tableView.reloadData()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView?.separatorStyle = .none
        tableView?.register(.init(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
//        tableView?.delegate = self
        tableView?.dataSource = self
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
            appDelegate.persistentContainer.viewContext.delete(commit)
            favoriteGames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try appDelegate.persistentContainer.viewContext.save()
            } catch {
                print("could not delete")
            }
        }
    }
}
