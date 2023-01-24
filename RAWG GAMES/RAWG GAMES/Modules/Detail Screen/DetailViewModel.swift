//
//  DetailViewModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 17.01.2023.
//

import Foundation

class DetailViewModel {
    
    private let model = DetailModel()
    
    var errorCaughtOnDetail: ((String) -> ())?
    var loadItems: ((Game) -> ())?
    
    init(id: Int) {
        model.delegate = self
        model.gameId = id
    }
    
    func didViewLoad() {
        model.fetchDetailData()
    }
}

extension DetailViewModel: DetailModelProtocol {
    
    func didDetailDataFetch() {
        let game: Game = .init(gameID: model.detailData?.id, slug: model.detailData?.slug, name: model.detailData?.name, released: model.detailData?.released, backgroundImage: model.detailData?.backgroundImage, website: model.detailData?.website, rating: (model.detailData?.rating)!, ratingTop: (model.detailData?.ratingTop)!, descriptionRaw: model.detailData?.descriptionRaw)
        
        loadItems?(game)
    }
    
    func didDetailDataCouldntFetch() {
        errorCaughtOnDetail?("no data")
    }
}
