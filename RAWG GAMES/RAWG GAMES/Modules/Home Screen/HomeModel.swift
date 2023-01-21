//
//  HomeModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import Foundation
import Alamofire
import UIKit
import CoreData

protocol HomeModelProtocol: AnyObject {
    func didDataFetch()
    func didCacheDataFetch()
    func didDataCouldntFetch()
}

class HomeModel {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private(set) var data: [Result] = []
    private(set) var genre: [[Genre]] = []
    private(set) var cacheData: [MainGameList] = []
    private var nextPageURL: String = ""
    
    weak var delegate: HomeModelProtocol?
    
    func fetchData() {
        
        if InternetManager.shared.isInternetActive() {
            AF.request("\(Constants.sharedURL)?key=\(Constants.apiKey)").responseDecodable(of: ApiGame.self) { game in
                guard let response = game.value else {
                    self.delegate?.didDataCouldntFetch()
                    print("no data")
                    return
                }
                
                self.nextPageURL = response.next
                self.data = response.results ?? []
                self.genre = self.data.map{$0.genres!}.compactMap{$0}
                self.delegate?.didDataFetch()
                
                for item in self.data {
                    self.saveToCoreData(item)
                }
            }
        } else {
            retrieveFromCoreData()
        }
    }

    func saveToCoreData(_ data: Result) {
        
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "MainGameList", in: context) {
            let object = NSManagedObject(entity: entity, insertInto: context)
            
            object.setValue(data.id, forKey: "id")
            object.setValue(data.name, forKey: "name")
            object.setValue(data.backgroundImage, forKey: "backgroundImage")
            object.setValue(data.released, forKey: "released")
            object.setValue(data.rating, forKey: "rating")
            object.setValue(data.ratingTop, forKey: "ratingTop")
//            object.setValue(genre.map{$0.map{$0.name}.description}, forKey: "genre")
            
            do {
                try context.save()
            } catch {
                print("Main page could not be cached to CoreData.")
            }
        }
    }
    
    func retrieveFromCoreData() {
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<MainGameList>(entityName: "MainGameList")
        
        do {
            let result = try context.fetch(request)
            self.cacheData = result
            delegate?.didCacheDataFetch()
        } catch {
            print("Error while retrieving data from cache.")
            delegate?.didDataCouldntFetch()
        }
    }
}

struct HomeCellModel {
    let id: Int
    let name: String
    let backgroundImage: String
    let released: String
    let rating: Double
    let ratingTop: Int
//    let genre: [Genre]
}
