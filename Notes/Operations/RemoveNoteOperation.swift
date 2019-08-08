//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by Dmitry Belkin on 05/08/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    private let removeFromDB: RemoveNoteDBOperation
    private let dbQueue: OperationQueue

    private(set) var result: Bool? = false

    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {

        removeFromDB = RemoveNoteDBOperation(note: note, notebook: notebook)
        self.dbQueue = dbQueue

        super.init()

        removeFromDB.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
            saveToBackend.completionBlock = {
                switch saveToBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                print("RemoveNoteOperation \(String(describing: self.result))")
                self.finish()
            }
            backendQueue.addOperation(saveToBackend)
        }
    }

    override func main() {
        dbQueue.addOperation(removeFromDB)
    }
}
