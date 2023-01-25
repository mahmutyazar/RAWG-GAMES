//
//  SecretKeys.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 20.01.2023.
//

import Foundation
import UIKit

struct Constants {
    static let sharedURL = "https://api.rawg.io/api/games"
    static let apiKey = "ed862e3ef473469890abd5142066f509"
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let context = Constants.appDelegate.persistentContainer.viewContext
}
