//
//  FavoritesViewModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 20.01.2023.
//

protocol FavoritesViewModelProtocol: AnyObject {
    func sendData(data: [FavoriteGame])
}

class FavoritesViewModel {
    
    private let model = FavoritesModel()
    
    weak var delegate: (FavoritesViewModelProtocol)?
    
    var errorCaught: ((String) -> ())?
    var loadItems: (([FavoriteGame]) -> ())?
    
    init() {
        model.delegate = self
    }
    
    func didViewLoad() {
        model.retrieveFavoritesFromCoreData()
    }
}

extension FavoritesViewModel: FavoritesModelProtocol {
    
    func didDataFetch() {
        let favoriteGames: [FavoriteGame] = model.data
        loadItems?(favoriteGames)
    }
    
    func didDataCouldntFetch() {
        errorCaught?("There is a problem. Try again later.")
    }
}
