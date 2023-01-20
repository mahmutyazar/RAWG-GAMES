//
//  DetailViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit
import CoreData
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var isFavorite: Bool = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var viewModel: DetailViewModel?
    
    var favoriteGame: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.clipsToBounds = true
        detailImageView.layer.cornerRadius = 15
        descriptionTextView.backgroundColor = .systemGray6
        
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
            self?.favoriteGame = item
            self?.detailImageView.kf.setImage(with: URL.init(string: item.backgroundImage ?? ""))
            self?.yearLabel.text = "Released: \(item.released?.prefix(4).description ?? "")"
            self?.websiteLabel.text = item.website ?? ""
            self?.rateLabel.text = "Rate: \(item.rating)/\(item.ratingTop)"
            self?.descriptionTextView.text = item.descriptionRaw ?? ""
        }
    }
    
    func saveFavoriteToCoreData(_ data: Game) {
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: context) {
            
            let gameObject = NSManagedObject(entity: entity, insertInto: context)
            gameObject.setValue(data.gameID, forKey: "id")
            gameObject.setValue(data.name ?? "", forKey: "name")
            gameObject.setValue(data.backgroundImage, forKey: "imageURL")
            gameObject.setValue(data.rating, forKey: "rating")
            gameObject.setValue(data.ratingTop, forKey: "ratingTop")
            gameObject.setValue(data.released, forKey: "released")
            gameObject.setValue(data.slug, forKey: "slug")
                        
            do {
                try context.save()
                print("saved")
            } catch {
                print("data could not save to coredata")
            }
        }
    }
    
    func deleteObject(_ data: Game) {
        
        
        
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
        isFavorite.toggle()
        setButtonBackground(view: sender, on: UIImage(systemName: "heart.fill")!, off: UIImage(systemName: "heart")!, onOffStatus: isFavorite)
        
        if isFavorite == true {
            saveFavoriteToCoreData(favoriteGame!)
        } else {
           print("deleted")
        }
    }
    
    func setButtonBackground(view: UIButton, on: UIImage, off: UIImage, onOffStatus: Bool) {
        switch onOffStatus {
        case true:
            view.setImage(on, for: .normal)
        default:
            view.setImage(off, for: .normal)
        }
    }
    
    
    func getID(_ id: Int) {
        viewModel = DetailViewModel(id: id)
    }
}
