//
//  DetailViewModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 17.01.2023.
//

import Foundation

class DetailViewModel {
    
    private let model = DetailModel()
    
    func didViewLoad() {
        model.fetchDetailData()
    }
}
