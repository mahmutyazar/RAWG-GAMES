//
//  NotesTableViewCell.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 22.01.2023.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .systemGray6
    }
    
}
