//
//  NotTakeViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit
import CoreData

class NoteTakeViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedNote: Notes? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = "Title".localized()
        descriptionLabel.text = "Description".localized()
        titleTextField.placeholder = "Insert title".localized()
        titleLabel.clipsToBounds = true
        titleLabel.layer.cornerRadius = 8
        descriptionLabel.clipsToBounds = true
        descriptionLabel.layer.cornerRadius = 8
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 8
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        descriptionTextView.delegate = self
        
        checkTextFields()
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveNote()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        deleteNotes()
    }
}
