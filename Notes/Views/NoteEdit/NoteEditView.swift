//
//  NotesEditView.swift
//  Notes
//
//  Created by Dmitry Belkin on 13/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

@IBDesignable
class NotesEditView: UIView, ColorPickerDelegate, UITextViewDelegate {
    @IBOutlet weak var noteEditView: UIView!
    @IBOutlet weak var colorPickerView: ColorPickerView!

    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var destroyDateSwitch: UISwitch!

    @IBOutlet weak var whiteColorView: ColorView!
    @IBOutlet weak var redColorView: ColorView!
    @IBOutlet weak var greenColorView: ColorView!
    @IBOutlet weak var paletteColorView: PaletteColorView!

    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteContentTextView: UITextView!

    var dateHeightConstraint: NSLayoutConstraint!
    private let datePickerHeight = CGFloat(200)
    public var destroyDateUsed = false {
        didSet {
            if destroyDateUsed {
                dateHeightConstraint.constant = datePickerHeight
            } else {
                dateHeightConstraint.constant = 0
            }

            self.setNeedsLayout()
            self.layoutSubviews()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func titleReturnButtonTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    func ColorSelected(sender: ColorPickerView, color: UIColor) {
        paletteColorView.shapeColor = color
        paletteColorView.selected = true
        paletteColorView.setNeedsDisplay()

        whiteColorView.selected = false
        redColorView.selected = false
        greenColorView.selected = false

        whiteColorView.setNeedsDisplay()
        redColorView.setNeedsDisplay()
        greenColorView.setNeedsDisplay()
    }

    @IBAction func whiteColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.selected = true
        redColorView.selected = false
        greenColorView.selected = false
        paletteColorView.selected = false

        whiteColorView.setNeedsDisplay()
        redColorView.setNeedsDisplay()
        greenColorView.setNeedsDisplay()
        paletteColorView.setNeedsDisplay()
    }
    
    @IBAction func redColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.selected = false
        redColorView.selected = true
        greenColorView.selected = false
        paletteColorView.selected = false

        whiteColorView.setNeedsDisplay()
        redColorView.setNeedsDisplay()
        greenColorView.setNeedsDisplay()
        paletteColorView.setNeedsDisplay()
    }

    @IBAction func greenColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.selected = false
        redColorView.selected = false
        greenColorView.selected = true
        paletteColorView.selected = false

        whiteColorView.setNeedsDisplay()
        redColorView.setNeedsDisplay()
        greenColorView.setNeedsDisplay()
        paletteColorView.setNeedsDisplay()
    }

    @IBAction func paletteColorViewLongPress(_ sender: Any) {
        colorPickerView.isHidden = false
    }

    @IBAction func switchChanged(_ sender: Any) {
        destroyDateUsed = destroyDateSwitch.isOn
//        if destroyDateSwitch.isOn {
//            dateHeightConstraint.constant = datePickerHeight
//        } else {
//            dateHeightConstraint.constant = 0
//        }
//
//        self.setNeedsLayout()
//        self.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.addSubview(xibView)

        whiteColorView.shapeColor = UIColor.white
        redColorView.shapeColor = UIColor.red
        greenColorView.shapeColor = UIColor.green

        noteContentTextView.delegate = self
        colorPickerView.delegate = self

        whiteColorView.selected = true

        dateHeightConstraint = NSLayoutConstraint(
            item: destroyDatePicker!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: destroyDateUsed ? datePickerHeight : 0)

        destroyDatePicker.addConstraints([dateHeightConstraint])

        self.setNeedsLayout()
        self.layoutSubviews()
    }

    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NoteEditView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
