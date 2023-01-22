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
        
    private(set) var data: [FavoriteGame] = []
    
    weak var delegate: FavoritesModelProtocol?
    
     func retrieveFavoritesFromCoreData() {
         
        let request = NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
        do {
            let result = try Constants.context.fetch(request)
            self.data = result
            self.delegate?.didDataFetch()
        } catch {
            print("Data could not retrieve from CoreData")
        }
    }
}
