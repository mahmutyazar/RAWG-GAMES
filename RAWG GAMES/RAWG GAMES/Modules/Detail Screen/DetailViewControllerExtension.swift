//
//  DetailViewControllerHelper.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 24.01.2023.
//

import UIKit
import CoreData

//MARK: -  WARNING! This extension belong to DetailViewController.

extension DetailViewController {
    
    func saveFavoriteToCoreData(_ data: Game) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "FavoriteGame", in: Constants.context) {
            
            let gameObject = NSManagedObject(entity: entity, insertInto: Constants.context)
            gameObject.setValue(data.gameID, forKey: "id")
            gameObject.setValue(data.name ?? "", forKey: "name")
            gameObject.setValue(data.backgroundImage, forKey: "imageURL")
            gameObject.setValue(data.rating, forKey: "rating")
            gameObject.setValue(data.ratingTop, forKey: "ratingTop")
            gameObject.setValue(data.released, forKey: "released")
            gameObject.setValue(data.slug, forKey: "slug")
            
            do {
                try Constants.context.save()
                print("saved")
            } catch {
                print("data could not save to coredata")
            }
        }
    }
    
    
    func setupBindings() {
        viewModel?.errorCaughtOnDetail = {[weak self] alert in
            let alert = UIAlertController(title: "ALERT".localized(), message: alert, preferredStyle: .alert)
            alert.addAction(.init(title: "OK".localized(), style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel?.loadItems = {[weak self] item in
            self?.favoriteGame = item
            self?.detailImageView.kf.setImage(with: URL.init(string: item.backgroundImage ?? ""))
            let released = "Released: ".localized()
            self?.yearLabel.text = "\(released)\(item.released?.prefix(4).description ?? "")"
            self?.websiteButton.titleLabel?.text = item.website ?? ""
            self?.websiteButton.setTitle("\(item.website ?? "rawg.io")", for: .normal)
            let rate = "Rate: ".localized()
            self?.rateLabel.text = "\(rate)\(item.rating)/\(item.ratingTop)"
            self?.descriptionTextView.text = item.descriptionRaw ?? ""
        }
    }
    
    func setupUI() {
        
        detailImageView.clipsToBounds = true
        detailImageView.layer.cornerRadius = 8
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 8
        yearLabel.clipsToBounds = true
        yearLabel.layer.cornerRadius = 8
        rateLabel.clipsToBounds = true
        rateLabel.layer.cornerRadius = 8
        websiteButton.clipsToBounds = true
        websiteButton.layer.cornerRadius = 8
        
        favoriteButton.layer.cornerRadius = favoriteButton.layer.bounds.height/2
        favoriteButton.clipsToBounds = true
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
    
    func deleteFavoriteFromCoreData() {
        
        let request = NSFetchRequest<FavoriteGame>(entityName: "FavoriteGame")
        request.predicate = NSPredicate(format: "id = %@", "\(favoriteGame?.gameID ?? 0)")
        
        do {
            let results = try Constants.context.fetch(request)
            if let object = results.first {
                Constants.context.delete(object)
                try Constants.context.save()
                print("deleted")
            }
        } catch {
            print(error)
        }
    }
}

extension DetailViewController: UNUserNotificationCenterDelegate {
    
    func localNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newNoteSaved),
                                               name: Notification.Name("NoteNotification"),
                                               object: nil)
    }
    
    @objc func newNoteSaved() {
        
        let notificationManager: NotificationProtocol = LocalNotificationManager.shared
        notificationManager.sendNotification(title: "Success!".localized(),
                                             message: "You have been added this game to favorites!".localized())
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.sound, .banner, .badge, .list])
    }
}
