//
//  DetailViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
//    private let viewModel = DetailViewModel()
    
    private var viewModel: DetailViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupBindings()
        viewModel?.didViewLoad()
    }
    
    func setupBindings() {
        viewModel?.errorCaughtOnDetail = {[weak self] alert in
            let alert = UIAlertController(title: "ALERT", message: alert, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel?.loadItems = {[weak self] item in
            self?.detailImageView.kf.setImage(with: URL.init(string: item.backgroundImage ?? ""))
            self?.nameLabel.text = item.name ?? ""
            self?.yearLabel.text = item.released?.prefix(4).description ?? ""
            self?.websiteLabel.text = item.website ?? ""
            self?.rateLabel.text = "\(item.rating)/\(item.ratingTop)"
            self?.descriptionTextView.text = item.descriptionRaw ?? ""
        }
    }
    
    func getID(_ id: Int) {
        viewModel = DetailViewModel(id: id)
    }
 }
