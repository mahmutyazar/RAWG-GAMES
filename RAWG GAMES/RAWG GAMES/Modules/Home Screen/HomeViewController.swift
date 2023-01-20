//
//  ViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 15.01.2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    private let viewModel = HomeViewModel()
    private var tableViewHelper: HomeTableViewHelper!

    var items : [HomeCellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        setupBindings()
        viewModel.didViewLoad()
    }
}

extension HomeViewController {
    
    private func setupUI() {
        tableViewHelper = .init(tableView: (homeTableView), viewModel: viewModel)
        homeTableView.delegate = self
    }
    
    func setupBindings() {
        
        viewModel.errorCaught = {[weak self] alert in
            let alert = UIAlertController(title: "ALERT", message: alert, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.loadItems = {[weak self] items in
            self?.tableViewHelper.setItems(items)
            self!.items = items
        }
    }
}

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailsVC = storyBoard.instantiateViewController(withIdentifier: "detailViewController") as? DetailViewController else {
            return
        }

        let id = items[indexPath.row].id
        detailsVC.getID(id)
        detailsVC.title = items[indexPath.row].name

        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
