//
//  NoteExtension.swift
//  Notes
//
//  Created by Dmitry Belkin on 02/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import Foundation
import UIKit

extension Note {
    var json: [String: Any] {
        var jsonDictionary: [String: Any] = [
            "title"      : self.title
            , "content"   : self.content
            , "uid"       : self.uid]

        if (self.importance.rawValue != Importance.usual.rawValue) {
            jsonDictionary["importance"] = self.importance.rawValue
        }

        if (!self.color.isWhite()) {
            jsonDictionary["color"] = self.color.toHexString()
        }

        if let selfDestructionDate = self.selfDestructionDate {
            jsonDictionary["selfDestructionDate"] = selfDestructionDate.timeIntervalSince1970
        }

        return jsonDictionary
    }

    static func parse(json: [String: Any]) -> Note? {
        var title = String()
        var content = String()
        var importance = Importance.usual
        var uid = String()
        var color = UIColor.white
        var selfDestructionDate: Date?

        for (key, value) in json {
            switch key {
            case "title":
                guard let titleJson = value as? String else { return nil }
                title = titleJson
            case "content":
                guard let contentJson = value as? String else { return nil }
                content = contentJson
            case "uid":
                guard let uidJson = value as? String else { return nil }
                uid = uidJson
            case "importance":
                guard let importanceRawValueJson = value as? String else { return nil }
                guard let importanceJson = Importance(rawValue: importanceRawValueJson) else { return nil }
                importance = importanceJson
            case "color":
                guard let colorHexJson = value as? String else { return nil }
                if let colorJson = UIColor(hexString: colorHexJson) {
                    color = colorJson
                } else {
                    return nil
                }
            case "selfDestructionDate":
                guard let dateJson = value as? TimeInterval else { return nil }
                selfDestructionDate = Date(timeIntervalSince1970: dateJson)
            default:
                return nil
            }
        }

        guard !title.isEmpty && !content.isEmpty && !uid.isEmpty else { return nil }

        return Note(title: title, content: content, importance: importance, uid: uid, color: color, selfDestructionDate: selfDestructionDate)
    }
}

extension UIColor {
    convenience init?(hexString: String) {
        let scanner = Scanner(string: hexString)

        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        } else {
            return nil
        }

        var color: UInt32 = 0
        guard scanner.scanHexInt32(&color) else {
            return nil
        }

        let r = Int( color             >> 16)
        let g = Int((color & 0x00FFFF) >> 8 )
        let b = Int((color & 0x0000FF) >> 0 )

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgba: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255)
        return String(format:"#%06x", rgba)
    }

    // изначально тут был про альфа-канал, поэтому скорее всего эта проверка уже не имеет смысла
    func isWhite() -> Bool {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)

        if (r.isEqual(to: 1.0) &&
            g.isEqual(to: 1.0) &&
            b.isEqual(to: 1.0)) {
            return true
        }

        return false
    }

}
