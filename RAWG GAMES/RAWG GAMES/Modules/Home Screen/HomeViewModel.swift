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
        model.fetchData()
    }
    
    func itemPressed(_ index: Int) {
        //TODO:  
    }
}

extension HomeViewModel: HomeModelProtocol {
    func didDataFetch() {
        let homeCellModel: [HomeCellModel] = model.data.map { .init(id: $0.id ?? 0, name: $0.name ?? "", backgroundImage: $0.backgroundImage ?? "", released: $0.released ?? "", rating: $0.rating ?? 0.0, ratingTop: $0.ratingTop ?? 0, genre: $0.genres! )}
        
        loadItems?(homeCellModel)
    }
    
    func didDataCouldntFetch() {
        errorCaught?("Seems like you're not connected to Internet. Please check your connection.")
    }
}

