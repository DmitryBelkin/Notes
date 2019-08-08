//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by Dmitry Belkin on 03/08/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: LoadNotesBackendResult?

    override func main() {
        result = .failure(.unreachable)
        print("LoadNotesBackendOperation succeeded")
        finish()
    }
}

