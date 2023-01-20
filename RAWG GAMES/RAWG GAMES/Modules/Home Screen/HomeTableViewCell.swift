//
//  HomeTableViewCell.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import Foundation
import UIKit
import Kingfisher



class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var releasedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gameImageView.clipsToBounds = true
        gameImageView.layer.cornerRadius = 12
    }

    func configure(with model: HomeCellModel) {
        gameImageView.kf.setImage(with: URL.init(string: model.backgroundImage))
        gameNameLabel.text = model.name
        releasedLabel.text = model.released.prefix(4).description
        ratingLabel.text = "\(model.rating)/\(model.ratingTop)"
//        genreLabel.text = model.genre.map{ element in element.name ?? ""}.joined(separator: ",")
        
    }
}
