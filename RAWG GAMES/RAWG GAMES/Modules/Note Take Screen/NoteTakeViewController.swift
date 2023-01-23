//
//  NotTakeViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit
import CoreData

class NoteTakeViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedNote: Notes? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        
        if titleTextField.text != nil {
            if descriptionTextView.text != nil {
                saveButton.isEnabled = false
            }
        }
        
        if selectedNote != nil {
            titleTextField.text = selectedNote?.title
            descriptionTextView.text = selectedNote?.desc
        }
    }
    
    func saveNote() {
        
        if titleTextField.text == "" {
            titleTextField.text = "You should fill all the blanks."
        } else if descriptionTextView.text == "" {
            descriptionTextView.text = "You should fill all the blanks."
        } else {
            
            if selectedNote == nil {
                let entity = NSEntityDescription.entity(forEntityName: "Notes", in: Constants.context)
                let newNote = Notes(entity: entity!, insertInto: Constants.context)
                newNote.id = Int64(truncating: noteList.count as NSNumber)
                newNote.title = titleTextField.text
                newNote.desc = descriptionTextView.text
                
                do {
                    try Constants.context.save()
                    noteList.append(newNote)
                    navigationController?.popViewController(animated: true)
                } catch {
                    print("note could not save")
                }
            } else {
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
                
                do {
                    let results: NSArray = try Constants.context.fetch(request) as NSArray
                    for result in results {
                        let note = result as! Notes
                        if note == selectedNote {
                            note.title = titleTextField.text
                            note.desc = descriptionTextView.text
                            try Constants.context.save()
                            navigationController?.popViewController(animated: true)
                        }
                    }
                } catch {
                    print("error")
                }
            }
            
            
        }
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveNote()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        do {
            let results: NSArray = try Constants.context.fetch(request) as NSArray
            for result in results {
                let note = result as! Notes
                if note == selectedNote {
                    
                    note.deletedDate = Date()
                    
                    try Constants.context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        } catch {
            print("error")
        }
    }
}

extension NoteTakeViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if titleTextField.text != nil && descriptionTextView.text != nil {
            saveButton.isEnabled = true
        }
    }
}
