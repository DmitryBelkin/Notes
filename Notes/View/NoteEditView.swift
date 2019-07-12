//
//  NotesEditView.swift
//  Notes
//
//  Created by Dmitry Belkin on 13/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

@IBDesignable
class NotesEditView: UIView {
    
    @IBOutlet weak var noteEditView: UIView!
    @IBOutlet weak var colorPickerPopupView: UIView!

    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var destroyDateSwitch: UISwitch!

    @IBOutlet weak var whiteColorView: ColorView!
    @IBOutlet weak var redColorView: ColorView!
    @IBOutlet weak var greenColorView: ColorView!
    @IBOutlet weak var paletteColorView: ColorView!

    var dateHeighcConstraint: NSLayoutConstraint!
    private let datePickerHeight = CGFloat(200)

    // нижние 3 метода мне не очень нравятся... как-то костыльно, но пока лучше не придумал
    @IBAction func whiteColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.selected = true
        redColorView.selected = false
        greenColorView.selected = false

        whiteColorView.setNeedsDisplay()
        redColorView.setNeedsDisplay()
        greenColorView.setNeedsDisplay()
    }
    
    @IBAction func redColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.selected = false
        redColorView.selected = true
        greenColorView.selected = false

        whiteColorView.setNeedsDisplay()
        redColorView.setNeedsDisplay()
        greenColorView.setNeedsDisplay()
    }

    @IBAction func greenColorTapped(_ sender: UITapGestureRecognizer) {
        whiteColorView.selected = false
        redColorView.selected = false
        greenColorView.selected = true

        whiteColorView.setNeedsDisplay()
        redColorView.setNeedsDisplay()
        greenColorView.setNeedsDisplay()
    }

    @IBAction func paletteColorViewLongPress(_ sender: Any) {
        colorPickerPopupView.isHidden = false
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        if destroyDateSwitch.isOn {
            dateHeighcConstraint.constant = datePickerHeight
        } else {
            dateHeighcConstraint.constant = 0
        }

        self.setNeedsLayout()
        self.layoutSubviews()
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

        whiteColorView.selected = true

        // @todo проверить параметры
        dateHeighcConstraint = NSLayoutConstraint(
            item: destroyDatePicker!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 0)

        destroyDatePicker.addConstraints([dateHeighcConstraint])
    }

    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NoteEditView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
