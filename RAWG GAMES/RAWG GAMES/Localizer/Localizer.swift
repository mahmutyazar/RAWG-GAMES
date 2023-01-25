//
//  Localizer.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 23.01.2023.
//

import Foundation

extension String {
    
    func localized() -> String {
     
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
