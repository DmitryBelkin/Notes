//
//  ColorPickerView.swift
//  Notes
//
//  Created by Dmitry Belkin on 13/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

internal protocol ColorPickerDelegate: NSObjectProtocol {
    func ColorSelected(sender: ColorPickerView, color: UIColor)
}

@IBDesignable
class ColorPickerView: UIView, HSBColorPickerDelegate {
    weak internal var delegate: ColorPickerDelegate?

    private let hsbColorPicker = HSBColorPicker()
    private let colorSelectorView = ColorSelectorView()
    private var label = UILabel()
    private var button = UIButton()
    private var slider = UISlider()
    private var startPointerNeeded = true
    private var brightness = Float(0.5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    @objc func buttonTapped() {
        self.isHidden = true
        let color = colorSelectorView.fillColor
        self.delegate?.ColorSelected(sender: self, color: color)
    }

    @objc func sliderValueChanged() {
        hsbColorPicker.brightnessValue = slider.value
        hsbColorPicker.setNeedsDisplay()

        let color = hsbColorPicker.getColorAtPoint(point: hsbColorPicker.currentPoint!)
        colorSelectorView.fillColor = color
        colorSelectorView.hexFillColorValue = color.toHexString()
        colorSelectorView.setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let currentColorViewSize = colorSelectorView.intrinsicContentSize
        colorSelectorView.frame = CGRect(
            origin: CGPoint(
                x: 8,
                y: 8),
            size: currentColorViewSize)

        let labelSize = label.intrinsicContentSize
        label.frame = CGRect(
            origin: CGPoint(
                x: colorSelectorView.frame.maxX + 20,
                y: colorSelectorView.frame.minY),
            size: labelSize)

        var sliderSize = slider.intrinsicContentSize
        sliderSize.width = bounds.maxX - label.frame.minX - 8
        slider.frame = CGRect(
            origin:
            CGPoint(
                x: label.frame.minX,
                y: colorSelectorView.frame.maxY - sliderSize.height),
            size: sliderSize)

        let buttonSize = button.intrinsicContentSize
        button.frame = CGRect(
            origin: CGPoint(
                x: (bounds.maxX - buttonSize.width - 2 * 8)/2,
                y: bounds.maxY - buttonSize.height - 8),
            size: buttonSize)

        var hsbColorPickerSize = hsbColorPicker.intrinsicContentSize
        hsbColorPickerSize.width  = bounds.maxX - 2 * 8
        hsbColorPickerSize.height = bounds.maxY - colorSelectorView.frame.maxY - (buttonSize.height + 8) - 10 - 20
        hsbColorPicker.frame = CGRect(
            origin: CGPoint(
                x: 8,
                y: colorSelectorView.frame.maxY + 20),
            size: hsbColorPickerSize)

        hsbColorPicker.currentPoint = CGPoint(x: hsbColorPicker.bounds.width/2, y: hsbColorPicker.bounds.height/2)

        let color = hsbColorPicker.getColorAtPoint(point: CGPoint(x: hsbColorPicker.bounds.width/2, y: hsbColorPicker.bounds.height/2))
        colorSelectorView.fillColor = color
        colorSelectorView.hexFillColorValue = color.toHexString()
        colorSelectorView.setNeedsDisplay()
    }

    private func setupViews() {
        slider.setValue(brightness, animated: true)
        slider.minimumValue = 0
        slider.maximumValue = 1

        hsbColorPicker.brightnessValue = brightness
        hsbColorPicker.delegate = self

        label.text = "Brightness"

        button.setTitle("Done", for: .normal)

        setNeedsLayout()

        button.setTitleColor(button.tintColor, for: .normal)

        addSubview(hsbColorPicker)
        addSubview(colorSelectorView)
        addSubview(label)
        addSubview(button)
        addSubview(slider)

        hsbColorPicker.translatesAutoresizingMaskIntoConstraints = true
        colorSelectorView.translatesAutoresizingMaskIntoConstraints = true
        label.translatesAutoresizingMaskIntoConstraints = true
        button.translatesAutoresizingMaskIntoConstraints = true
        slider.translatesAutoresizingMaskIntoConstraints = true

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        _ = hsbColorPicker.layer.sublayers?.popLast()

        hsbColorPicker.currentPoint = point

        colorSelectorView.fillColor = color
        colorSelectorView.hexFillColorValue = color.toHexString()
        colorSelectorView.setNeedsDisplay()
    }
}
