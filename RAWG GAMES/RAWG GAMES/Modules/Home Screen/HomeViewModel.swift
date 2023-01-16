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
        <#code#>
    }
    
    func didDataCouldntFetch() {
        errorCaught?("Seems like you're not connected to Internet. Please check your connection.")
    }
}

