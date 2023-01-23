//
//  ViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 15.01.2023.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let animationView = LottieAnimationView()
    private let viewModel = HomeViewModel()
    private var tableViewHelper: HomeTableViewHelper!

    var items : [HomeCellModel] = []
    var searchResults: [HomeCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = NSLocalizedString("All Games", comment: "")
        
        setupAnimation()
        setupUI()
        setupBindings()
        viewModel.didViewLoad()
    
    }
    
    private func setupAnimation() {
        animationView.animation = LottieAnimation.named("gaming")
        animationView.frame = view.bounds
        animationView.backgroundColor = .systemGray6
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
}

extension HomeViewController {
    
    private func setupUI() {
        tableViewHelper = .init(tableView: (homeTableView), viewModel: viewModel, searchBar: searchBar, searchResults: searchResults, navigationController: navigationController!)
    }
    
    func setupBindings() {
        
        viewModel.errorCaught = {[weak self] alert in
            let alert = UIAlertController(title: "ALERT", message: alert, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.loadItems = {[weak self] items in
            self?.tableViewHelper.setItems(items)
            self!.animationView.stop()
            self!.animationView.isHidden = true
            self!.items = items
        }
    }
}
