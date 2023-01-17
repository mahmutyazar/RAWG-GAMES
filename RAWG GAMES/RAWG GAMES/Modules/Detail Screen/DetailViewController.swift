//
//  DetailViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit

class DetailViewController: UIViewController {

    private let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewModel.didViewLoad()
    }
}
