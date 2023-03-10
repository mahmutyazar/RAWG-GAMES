//
//  HomeViewModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import Foundation

class HomeViewModel {
    
    private let model = HomeModel()
    
    var errorCaught: ((String) -> ())?
    var loadItems: (([HomeCellModel]) -> ())?
    
    init() {
        model.delegate = self
    }
    
    func didViewLoad() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.model.fetchData()
        })
    }
}

extension HomeViewModel: HomeModelProtocol {
    
    func didDataFetch() {
        
        let homeCellModel: [HomeCellModel] = model.data.map { .init(id: $0.id ?? 0, name: $0.name ?? "", backgroundImage: $0.backgroundImage ?? "", released: $0.released ?? "", rating: $0.rating ?? 0.0, ratingTop: $0.ratingTop ?? 0)}
        
        loadItems?(homeCellModel)
    }
    
    func didCacheDataFetch() {
        
        let homeCellModel: [HomeCellModel] = model.cacheData.map { .init(id: Int($0.id ), name: $0.name ?? "", backgroundImage: $0.backgroundImage ?? "", released: $0.released ?? "", rating: $0.rating , ratingTop: Int($0.ratingTop))}
        
        loadItems?(homeCellModel)
    }
    
    func didDataCouldntFetch() {
        errorCaught?("Seems like you're not connected to Internet. Please check your connection.".localized())
    }
}

