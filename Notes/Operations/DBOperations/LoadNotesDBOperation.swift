//
//  LoadNotesDBOperation.swift
//  Notes
//
//  Created by Dmitry Belkin on 03/08/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    var result: [Note]?

    override func main() {
        notebook.loadFromFile()
        result = notebook.notes
        finish()
    }
}
