//
//  DetailModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 17.01.2023.
//

import Foundation
import UIKit
import Alamofire
import CoreData

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
    
    private(set) var detailData: ApiGameDetail?
    private(set) var cacheDetailData: [FavoriteGame] = []
    
    weak var delegate: DetailModelProtocol?
    
    func fetchDetailData() {
        
        if InternetManager.shared.isInternetActive() {
            guard let gameId = gameId else {return}
            
            AF.request("\(Constants.sharedURL)/\(gameId)?key=\(Constants.apiKey)").responseDecodable(of: ApiGameDetail.self) { detail in
                guard let response = detail.value else {
                    self.delegate?.didDetailDataCouldntFetch()
                    print("no detail")
                    return
                }
                self.detailData = response
                self.delegate?.didDetailDataFetch()
            
                
            }
        } else {
                //retrieve from CoreData
        }
    }
}
