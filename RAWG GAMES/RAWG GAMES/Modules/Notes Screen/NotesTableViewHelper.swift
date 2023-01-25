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
        tableView?.separatorStyle = .none
        tableView?.register(.init(nibName: "NotesTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.dataSource = self
        tableView?.keyboardDismissMode = .onDrag
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
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 15
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 16

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 15
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 8, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
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


//MARK: -  WARNING! This extension belong to NotesViewController, does not belong to NotesTableViewHelper that you're currently in.

extension NotesViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if noteList.count > 0 {
            self.infoView.isHidden = true
        } else {
            self.infoView.isHidden = false
        }
        
        
        notesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            
            let indexPath = notesTableView.indexPathForSelectedRow!
            let noteDetail = segue.destination as? NoteTakeViewController
            let selectedNote: Notes!
            
            selectedNote = tableViewHelper.nonDeletedNotes()[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            notesTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        addButtonView.layer.cornerRadius = addButtonView.layer.bounds.height/2
        addButtonView.clipsToBounds = true
    }
    
    func setupUI() {
        tableViewHelper = .init(tableView: notesTableView, navigationController: navigationController!)
        self.tableViewHelper.setItems(with: noteList)
        self.notesTableView.delegate = self
        notesTableView.reloadData()
        
    }
    
    func cleanNotes() {
        
        let alert = UIAlertController(title: "WARNING".localized(),
                                      message: "All notes will be deleted. Are you sure?".localized(),
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "DELETE".localized(),
                                     style: UIAlertAction.Style.default) { [self] UIAlertAction in
            do {
                tableViewHelper.deleteAllRecords(entity: "Notes")
                DispatchQueue.main.async {
                    noteList.removeAll()
                    self.notesTableView.reloadData()
                    self.infoView.isHidden = false
                }
            } catch {
                print("could not delete")
            }
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL".localized(),
                                         style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func performSegue() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NoteTakeVC")
        vc.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
}
