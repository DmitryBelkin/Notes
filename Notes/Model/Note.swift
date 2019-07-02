//
//  Note.swift
//  Notes
//
//  Created by Dmitry Belkin on 02/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import Foundation
import UIKit

enum Importance: String {
    case unimportant = "unimportant"
    case usual       = "usual"
    case important   = "important"
}

struct Note {
    let title: String
    let content: String
    let importance: Importance
    let uid: String
    let color: UIColor
    let selfDestructionDate: Date?

    init?(title : String
        , content : String
        , importance : Importance
        , uid : String = UUID().uuidString
        , color : UIColor = UIColor.white
        , selfDestructionDate : Date? = nil) {

        guard !title.isEmpty && !content.isEmpty else {
            return nil
        }

        self.title = title
        self.content = content
        self.importance = importance
        self.uid = uid
        self.color = color
        self.selfDestructionDate = selfDestructionDate
    }
}
