//
//  NotesTableViewHelper.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 22.01.2023.
//

import UIKit
import CoreData

var noteList = [Notes]()

class NotesTableViewHelper: NSObject {
    
    private var tableView: UITableView?
    private var navigationController: UINavigationController?
    private let cellIdentifier = "NotesTableViewCell"
    
    private var firstLoad = true
    
    init(tableView: UITableView, navigationController: UINavigationController) {
        self.tableView = tableView
        self.navigationController = navigationController
        super.init()
        
        checkFirstLoad()
        setupTableView()
    }
    
    func checkFirstLoad() {
        
        if firstLoad {
            firstLoad = false
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
            
            do {
                let results: NSArray = try Constants.context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Notes
                    noteList.append(note)
                }
            } catch {
                print("error")
            }
        }
    }
    
    func nonDeletedNotes() -> [Notes] {
        
        var noDeleteNoteList = [Notes]()
        for note in noteList {
            if note.deletedDate == nil {
                noDeleteNoteList.append(note)
            }
        }
        return noDeleteNoteList
        
    }
    
    func deleteAllRecords(entity : String) {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try Constants.context.execute(deleteRequest)
            try Constants.context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    private func setupTableView() {
        tableView?.separatorStyle = .singleLine
        tableView?.register(.init(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.dataSource = self
    }
    
    func setItems(with items: [Notes]) {
        noteList = items
        tableView?.reloadData()
    }
    
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "editNote", sender: self)
        
    }
}

extension NotesTableViewHelper: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NotesTableViewCell
        let thisNote: Notes!
        thisNote = nonDeletedNotes()[indexPath.row]
        cell.titleLabel.text = thisNote.title
        cell.descriptionLabel.text = thisNote.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = nonDeletedNotes()[indexPath.row]
            Constants.context.delete(commit)
            
            noteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try Constants.context.save()
            } catch {
                print("could not delete")
            }
        }
    }
}


