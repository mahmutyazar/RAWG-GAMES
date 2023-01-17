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
    
    let gameID: Int = 3498
    let apiKey: String = "ed862e3ef473469890abd5142066f509"
    
    private(set) var detailData: Game?
    
    weak var delegate: DetailModelProtocol?
    
    func fetchDetailData() {
        
        AF.request("https://api.rawg.io/api/games/3498?key=ed862e3ef473469890abd5142066f509").responseDecodable(of: ApiGameDetail.self) { detail in
            guard let response = detail.value else {
                self.delegate?.didDetailDataCouldntFetch()
                print("no detail")
                return
            }
            
            print(response)
            
            
        }
        
    }
}
