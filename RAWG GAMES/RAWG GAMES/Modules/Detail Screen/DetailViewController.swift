//
//  DetailViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit
import CoreData
import Kingfisher
import SafariServices

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var viewModel: DetailViewModel?
    var isFavorite: Bool = false
    var favoriteGame: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        viewModel?.didViewLoad()
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
        isFavorite.toggle()
        
        setButtonBackground(view: sender, on: UIImage(systemName: "heart.fill")!,
                            off: UIImage(systemName: "heart")!,
                            onOffStatus: isFavorite)
        
        if isFavorite == true {
            localNotification()
            UNUserNotificationCenter.current().delegate = self
            saveFavoriteToCoreData(favoriteGame!)
            NotificationCenter.default.post(name: Notification.Name("NoteNotification"),
                                            object: nil)
        } else {
            deleteFavoriteFromCoreData()
        }
    }
    
    @IBAction func websiteClicked(_ sender: Any) {
        
        if let url = URL(string: "\(favoriteGame?.website ?? "")") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
}
