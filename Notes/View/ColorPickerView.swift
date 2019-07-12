//
//  ColorPickerView.swift
//  Notes
//
//  Created by Dmitry Belkin on 13/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPickerView: UIView, HSBColorPickerDelegate {
    private let hsbColorPicker = HSBColorPicker()
    private let currentColorView = CurrentColorView()
    private var label = UILabel()
    private var button = UIButton()
    private var slider = UISlider()

    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        currentColorView.fillColor = color
        currentColorView.hexFillColorValue = color.toHexString()
        currentColorView.setNeedsDisplay()
    }

    var brightness = Float(0.5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // как-то по-другому выходить и отдавать цвет 1-ой вьюхе
    @objc func buttonTapped() {
        self.isHidden = true
    }

    @objc func sliderValueChanged() {
        hsbColorPicker.brightnessValue = slider.value
        hsbColorPicker.setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let currentColorViewSize = currentColorView.intrinsicContentSize
        currentColorView.frame = CGRect(
            origin: CGPoint(
                x: 8,
                y: 8),
            size: currentColorViewSize)

        let labelSize = label.intrinsicContentSize
        label.frame = CGRect(
            origin: CGPoint(
                x: currentColorView.frame.maxX + 20,
                y: currentColorView.frame.minY), // заменить
            size: labelSize)

        var sliderSize = slider.intrinsicContentSize
        sliderSize.width = bounds.maxX - label.frame.minX - 8
        slider.frame = CGRect(
            origin:
            CGPoint(
                x: label.frame.minX,
                y: currentColorView.frame.maxY - sliderSize.height),
            size: sliderSize)

        let buttonSize = button.intrinsicContentSize
        button.frame = CGRect(
            origin: CGPoint(
                x: (bounds.maxX - buttonSize.width - 2*8)/2,
                y: bounds.maxY - buttonSize.height - 8),
            size: buttonSize)

        var hsbColorPickerSize = hsbColorPicker.intrinsicContentSize
        hsbColorPickerSize.width  = bounds.maxX - 2 * 8
        hsbColorPickerSize.height = bounds.maxY - currentColorView.frame.maxY - (buttonSize.height + 8) - 10 - 20
        hsbColorPicker.frame = CGRect(
            origin: CGPoint(
                x: 8,
                y: currentColorView.frame.maxY + 20),
            size: hsbColorPickerSize)
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
        addSubview(currentColorView)
        addSubview(label)
        addSubview(button)
        addSubview(slider)

        hsbColorPicker.translatesAutoresizingMaskIntoConstraints = true
        currentColorView.translatesAutoresizingMaskIntoConstraints = true
        label.translatesAutoresizingMaskIntoConstraints = true
        button.translatesAutoresizingMaskIntoConstraints = true
        slider.translatesAutoresizingMaskIntoConstraints = true

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
}
