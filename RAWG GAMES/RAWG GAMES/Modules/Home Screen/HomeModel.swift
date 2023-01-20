//
//  HomeModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import Foundation
import Alamofire
import UIKit

protocol HomeModelProtocol: AnyObject {
    func didDataFetch()
    func didDataCouldntFetch()
}

class HomeModel {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let apiKey: String = "ed862e3ef473469890abd5142066f509"
    
    private(set) var data: [Result] = []
    
    weak var delegate: HomeModelProtocol?
    
    func fetchData() {
        
        AF.request("https://api.rawg.io/api/games?key=\(apiKey)&page=14").responseDecodable(of: ApiGame.self) { game in
            guard let response = game.value else {
                self.delegate?.didDataCouldntFetch()
                print("no data")
                return
            }
            self.data = response.results ?? []
            self.delegate?.didDataFetch()
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
    let genre: [Genre]
}
