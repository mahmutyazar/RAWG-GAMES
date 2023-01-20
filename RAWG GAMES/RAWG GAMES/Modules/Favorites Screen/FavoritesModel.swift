//
//  FavoritesModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 20.01.2023.
//

import Foundation
import UIKit
import CoreData

protocol FavoritesModelProtocol: AnyObject {
    func didDataFetch()
    func didDataCouldntFetch()
}

class FavoritesModel {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private(set) var data: [FavoriteGame] = []
    
    weak var delegate: FavoritesModelProtocol?
    
     func retrieveFavoritesFromCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
        do {
            let result = try context.fetch(request)
            self.data = result
            self.delegate?.didDataFetch()
        } catch {
            print("Data could not retrieve from CoreData")
        }
    }
    
    
    
}
