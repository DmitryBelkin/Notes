//
//  NotebookViewController.swift
//  Notes
//
//  Created by Dmitry Belkin on 27/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

class NotebookViewController: UITableViewController {
    private var notebook = FileNotebook()

    let commonQueue  = OperationQueue()
    let backendQueue = OperationQueue()
    let dbQueue      = OperationQueue()

    override func viewWillAppear(_ animated: Bool) {
        let loadNotesOperation = LoadNotesOperation(
            notebook     : notebook,
            backendQueue : backendQueue,
            dbQueue      : dbQueue
        )

        let updateUI = BlockOperation {
            self.tableView.reloadData()
            print("load notes is finished? \(loadNotesOperation.isFinished)")
        }

        updateUI.addDependency(loadNotesOperation)
        commonQueue.addOperation(loadNotesOperation)
        OperationQueue.main.addOperation(updateUI)

        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }

        let note = notebook.notes[indexPath.row]
        noteCell.titleLabel.text = note.title
        noteCell.contentLabel.text = note.content
        noteCell.colorImageView.backgroundColor = note.color

        return noteCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.notes.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removeNoteOperation = RemoveNoteOperation(
                note: notebook.notes[indexPath.row],
                notebook: notebook,
                backendQueue: backendQueue,
                dbQueue: dbQueue)
            commonQueue.addOperation(removeNoteOperation)
            let deleteCellOperation = BlockOperation {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            deleteCellOperation.addDependency(removeNoteOperation)
            OperationQueue.main.addOperation(deleteCellOperation)

//            notebook.remove(with: notebook.notes[indexPath.row].uid)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? NoteEditViewController {
            if segue.identifier == "ShowEditNoteScreen" {
                let cell = sender as! NoteTableViewCell
                if let indexPath = tableView.indexPath(for: cell) {
                    controller.note = notebook.notes[indexPath.row]
                    controller.callback = {
                        editedNote in
                        ///
                        let backendQueue = OperationQueue()
                        let dbQueue = OperationQueue()
                        let commonQueue = OperationQueue()

                        let removeNoteOperation = RemoveNoteOperation(
                            note: self.notebook.notes[indexPath.row],
                            notebook: self.notebook,
                            backendQueue: backendQueue,
                            dbQueue: dbQueue
                        )
                        commonQueue.addOperation(removeNoteOperation)

                        let updateUI = BlockOperation {
                            print(self.notebook.notes.count)
                        }
                        OperationQueue.main.addOperation(updateUI)
                        ///
                        // first delete
                        self.notebook.remove(with: self.notebook.notes[indexPath.row].uid)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)

                        // then add
                        self.notebook.add(editedNote!)
                    }
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            } else if segue.identifier == "ShowCreateNoteScreen" {
                controller.callback = {
                    editedNote in
                    if let newNote = editedNote {
                        self.notebook.add(newNote)
                    }
                }
            }
        }
    }

}
