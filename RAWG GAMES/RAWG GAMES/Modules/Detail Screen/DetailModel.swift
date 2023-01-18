//
//  DetailModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 17.01.2023.
//

import Foundation
import UIKit
import Alamofire

protocol DetailModelProtocol: AnyObject {
    func didDetailDataFetch()
    func didDetailDataCouldntFetch()
}

class DetailModel {
    
    var gameId: Int? {
        didSet {
            fetchDetailData()
        }
    }
    
    let apiKey: String = "ed862e3ef473469890abd5142066f509"
    
    private(set) var detailData: ApiGameDetail?
    
    weak var delegate: DetailModelProtocol?
    
    func fetchDetailData() {
      
        guard let gameId = gameId else {return}
        
        AF.request("https://api.rawg.io/api/games/\(gameId)?key=ed862e3ef473469890abd5142066f509").responseDecodable(of: ApiGameDetail.self) { detail in
            guard let response = detail.value else {
                self.delegate?.didDetailDataCouldntFetch()
                print("no detail")
                return
            }
            self.detailData = response
            self.delegate?.didDetailDataFetch()
        }
    }
}
