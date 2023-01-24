//
//  NotesViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var addButtonView: UIView!
    
    var tableViewHelper: NotesTableViewHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes".localized()
        infoLabel.text = "Notes list is empty.".localized()
        
        setupUI()
    }
    
    @IBAction func addButton(_ sender: Any) {
        performSegue()
    }
    
    @IBAction func cleanButton(_ sender: Any) {
        cleanNotes()
    }
}
