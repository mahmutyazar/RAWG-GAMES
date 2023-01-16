//
//  HomeModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import Foundation
import Alamofire

protocol HomeModelProtocol: AnyObject {
    func didDataFetch()
    func didDataCouldntFetch()
}

class HomeModel {
    
    let apiKey: String = "ed862e3ef473469890abd5142066f509"
    
    private var data: [Result] = []
    
    weak var delegate: HomeModelProtocol?
    
    func fetchData() {
        
        AF.request("https://api.rawg.io/api/games?key=\(apiKey)").responseDecodable(of: ApiGame.self) { game in
            guard let response = game.value else {
                self.delegate?.didDataCouldntFetch()
                return
            }
            self.data = response.results ?? []
            self.delegate?.didDataFetch()
            print(self.data)
        }
        
    }
    
}
