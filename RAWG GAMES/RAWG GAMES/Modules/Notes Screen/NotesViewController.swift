//
//  NotesViewController.swift
//  RAWG GAMES
//
//  Created by Mahmut Yazar on 16.01.2023.
//

import UIKit

class NotesViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var addButtonView: UIView!
    
    private var tableViewHelper: NotesTableViewHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes".localized()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func setupUI() {
        tableViewHelper = .init(tableView: notesTableView, navigationController: navigationController!)
        self.tableViewHelper.setItems(with: noteList)
        self.notesTableView.delegate = self
        notesTableView.reloadData()

    }
    
    override func viewDidLayoutSubviews() {
        addButtonView.layer.cornerRadius = addButtonView.layer.bounds.height/2
        addButtonView.clipsToBounds = true
    }
    
    @IBAction func addButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NoteTakeVC")
        vc.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    @IBAction func cleanButton(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "WARNING".localized(), message: "All notes will be deleted. Are you sure?".localized(), preferredStyle: .alert)
    
        let okAction = UIAlertAction(title: "DELETE".localized(), style: UIAlertAction.Style.default) { [self] UIAlertAction in
            do {
                tableViewHelper.deleteAllRecords(entity: "Notes")
                DispatchQueue.main.async {
                    noteList.removeAll()
                    self.notesTableView.reloadData()
                }
            } catch {
                print("could not delete")
            }
        }

        let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)

    }
}
