//
//  ViewController.swift
//  Notes
//
//  Created by Dmitry Belkin on 02/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

class NoteEditViewController: UIViewController, UITextViewDelegate {

    var callback: ((Note?) -> Void)?
    var note: Note?
    @IBOutlet weak var noteEditView: NotesEditView!

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        var color = UIColor.white
        if noteEditView.whiteColorView.selected {
            color = UIColor.white
        } else if noteEditView.redColorView.selected {
            color = UIColor.red
        } else if noteEditView.greenColorView.selected {
            color = UIColor.green
        } else {
            color = noteEditView.paletteColorView.shapeColor
        }

        let destructionDate = noteEditView.destroyDatePicker.date

        let editedNote = Note(
            title: noteEditView.noteTitleTextField.text!,
            content: noteEditView.noteContentTextView.text,
            importance: Importance.usual,
            color: color,
            selfDestructionDate: noteEditView.destroyDateSwitch.isOn ? destructionDate : nil)

        callback?(editedNote)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        noteEditView.noteTitleTextField.text = note?.title
        noteEditView.noteContentTextView.text = note?.content
        if let date = note?.selfDestructionDate {
            noteEditView.destroyDateSwitch.isOn = true
            noteEditView.destroyDateUsed = true
            noteEditView.destroyDatePicker.date = date
        }

        if noteEditView.whiteColorView.shapeColor == note?.color {
            noteEditView.whiteColorView.selected = true
            noteEditView.redColorView.selected = false
            noteEditView.greenColorView.selected = false
            noteEditView.paletteColorView.selected = false
        } else if noteEditView.redColorView.shapeColor == note?.color {
            noteEditView.whiteColorView.selected = false
            noteEditView.redColorView.selected = true
            noteEditView.greenColorView.selected = false
            noteEditView.paletteColorView.selected = false
        } else if noteEditView.greenColorView.shapeColor == note?.color {
            noteEditView.whiteColorView.selected = false
            noteEditView.redColorView.selected = false
            noteEditView.greenColorView.selected = true
            noteEditView.paletteColorView.selected = false
        } else if noteEditView.paletteColorView.shapeColor == note?.color {
            noteEditView.whiteColorView.selected = false
            noteEditView.redColorView.selected = false
            noteEditView.greenColorView.selected = false
            noteEditView.paletteColorView.selected = true
        } else {
//            noteEditView.colorPickerView.
        }
        
        // Do any additional setup after loading the view.
    }


}

