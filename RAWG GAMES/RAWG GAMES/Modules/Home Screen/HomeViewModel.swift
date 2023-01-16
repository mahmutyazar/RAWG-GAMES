//
//  HomeViewModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import Foundation

class HomeViewModel {
    
    private let model = HomeModel()
    
    func didViewLoad() {
        model.fetchData()
    }
}
