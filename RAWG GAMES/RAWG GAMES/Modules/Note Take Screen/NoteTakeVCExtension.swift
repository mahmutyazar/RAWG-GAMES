//
//  NoteTakeVCExtension.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 24.01.2023.
//

import UIKit
import CoreData

extension NoteTakeViewController {
    
    func saveNote() {
        
        if titleTextField.text == "" {
            titleTextField.text = "You should fill all the blanks.".localized()
        } else if descriptionTextView.text == "" {
            descriptionTextView.text = "You should fill all the blanks.".localized()
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
    
    func checkTextFields() {
        
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
    
    func deleteNotes() {
        
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
