//
//  ViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 15.01.2023.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let animationView = LottieAnimationView()
    let viewModel = HomeViewModel()
    var tableViewHelper: HomeTableViewHelper!
    
    var items : [HomeCellModel] = []
    var searchResults: [HomeCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Random Games".localized()
        searchBar.placeholder = "Search whatever you looking for...".localized()
        segmentedControl.setTitle("RATE".localized(), forSegmentAt: 1)
        
        setupAnimation()
        setupUI()
        setupBindings()
        viewModel.didViewLoad()
    }
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        sortTable()
    }
}
