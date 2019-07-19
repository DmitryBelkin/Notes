//
//  FileNotebook.swift
//  Notes
//
//  Created by Dmitry Belkin on 02/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import Foundation
import CocoaLumberjack

protocol Notebook {
    func add(_ note: Note)
    func remove(with uid: String)
    func saveToFile()
    func loadFromFile()
}

class FileNotebook : Notebook {
    init(storeFileName: String = "Notes.json") {
        self.notes = [Note]()
        self.storeFileName = storeFileName

        DDLog.add(DDOSLogger.sharedInstance)
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    private static let notebooksDirectory = "Notebooks"
    private let storeFileName: String
    private(set) var notes: [Note]
    private let fileLogger: DDFileLogger = DDFileLogger()

    public func add(_ note: Note) {
        var noteExists = false
        for (i, nextNote) in self.notes.enumerated() {
            if nextNote.uid == note.uid {
                self.notes[i] = note
                noteExists = true
                break
            }
        }

        if !noteExists {
            notes.append(note)
        }
    }

    public func remove(with uid: String) {
        //TODO: Use filterinf with condition or predicate
        for (i, nextNote) in self.notes.enumerated() {
            if nextNote.uid == uid {
                self.notes.remove(at: i)
                break
            }
        }
    }

    public func saveToFile() {
        let jsonObjects = self.notes.map( { $0.json } )

        guard let cachesDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let targetDirectoryUrl = cachesDirectoryUrl.appendingPathComponent(FileNotebook.notebooksDirectory)
        //TODO: use guard let:
//        guard !directoryExistsAtPath(targetDirectoryUrl.path), !tryToCreateDirectory(targetDirectoryUrl) else {
//            return
//        }
        if !directoryExistsAtPath(targetDirectoryUrl.path) {
            if !tryToCreateDirectory(targetDirectoryUrl) {
                return
            }
        }

        let storeFileUrl = targetDirectoryUrl.appendingPathComponent(storeFileName)
        var data = Data()
        do {
            data = try JSONSerialization.data(withJSONObject: jsonObjects, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            DDLogError("Ошибка создания Data из Json")
            return
        }

        if FileManager.default.fileExists(atPath: storeFileUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: storeFileUrl.path)
            } catch {
                DDLogError("Ошибка удаления файла")
                return
            }
        }

        if !FileManager.default.createFile(atPath: storeFileUrl.path, contents: data,
                                           attributes: nil) {
            DDLogError("Ошибка создания файла")
            return
        }
    }

    public func loadFromFile() {
        guard let cachesDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let targetDirectoryUrl = cachesDirectoryUrl.appendingPathComponent(FileNotebook.notebooksDirectory)
        let loadFileUrl = targetDirectoryUrl.appendingPathComponent(storeFileName)

        if !FileManager.default.fileExists(atPath: loadFileUrl.path) {
            DDLogError("Ошибка: файла с заметками не существует")
            return
        }

        var data = Data()
        do {
            data = try Data(contentsOf: loadFileUrl, options: [])
        } catch {
            DDLogError("Ошибка чтения данных из файла")
            return
        }

        var notes: [AnyObject]? = [AnyObject]()
        do {
            notes = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject]
        } catch {
            DDLogError("Ошибка парсинга данных, считанных из файла")
            return
        }

        if let notes = notes {
            for element: AnyObject in notes {
                guard let dict = element as? [String: Any] else { return }
                if let note = Note.parse(json: dict) {
                    self.add(note)
                }
            }
        }
    }

}

extension FileNotebook {
    private func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    private func tryToCreateDirectory(_ url: URL) -> Bool {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            DDLogError("Ошибка создания директории")
        }
        return false
    }
}
