//
//  Service Model.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ApiGame = try? JSONDecoder().decode(ApiGame.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let apiGame = try? JSONDecoder().decode(ApiGame.self, from: jsonData)

import Foundation

// MARK: - ApiGame
struct ApiGame: Codable {
    
    let next: String
    let results: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case results
        case next
    }
}

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let slug, name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case genres
    }
}

// MARK: - Genre
struct Genre: Codable {
    let name, slug: String?
}
