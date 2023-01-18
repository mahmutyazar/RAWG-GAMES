//
//  DetailServiceModel.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 17.01.2023.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let aPIGameDetail = try? JSONDecoder().decode(APIGameDetail.self, from: jsonData)

import Foundation

// MARK: - APIGameDetail
struct ApiGameDetail: Codable {
    let id: Int?
    let slug, name, description: String?
    let released: String?
    let backgroundImage: String?
    let website: String?
    let rating: Double?
    let ratingTop: Int?
    let descriptionRaw: String?

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case description
        case released
        case backgroundImage = "background_image"
        case website, rating
        case ratingTop = "rating_top"
        case descriptionRaw = "description_raw"
    }
}

struct Game {
    var gameID: Int?
    var slug: String?
    var name: String?
    var released: String?
    var backgroundImage: String?
    var website: String?
    var rating: Double
    var ratingTop: Int
    var descriptionRaw: String?
}
