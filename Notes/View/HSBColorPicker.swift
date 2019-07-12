//
//  HSBColorPicker.swift
//  Notes
//
//  Created by Dmitry Belkin on 14/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

internal protocol HSBColorPickerDelegate: NSObjectProtocol {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State)
}

@IBDesignable
class HSBColorPicker: UIView {
    var brightnessValue = Float(0.5)

    weak internal var delegate: HSBColorPickerDelegate?

    var targetRect = UIScreen.main.bounds

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 400)
    }

    @IBInspectable var elementSize: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }

    private func initialize() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    override func draw(_ rect: CGRect) {
        targetRect = rect
        let context = UIGraphicsGetCurrentContext()
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            let saturation = CGFloat(rect.height - y) / rect.height
            let brightness = CGFloat(brightnessValue)
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }

    func getColorAtPoint(point: CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)),
                                   y: elementSize * CGFloat(Int(point.y / elementSize)))
        let saturation = CGFloat(targetRect.height - roundedPoint.y) / targetRect.height
        let brightness = CGFloat(brightnessValue)
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

//    func getPointForColor(color: UIColor) -> CGPoint {
//        var hue: CGFloat = 0.0
//        var saturation: CGFloat = 0.0
//        var brightness: CGFloat = 0.0
//        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
//
//        var yPos:CGFloat = 0
//        let halfHeight = (self.bounds.height / 2)
//        if (brightness >= 0.99) {
//            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
//            yPos = CGFloat(percentageY) * halfHeight
//        } else {
//            //use brightness to get Y
//            yPos = halfHeight + halfHeight * (1.0 - brightness)
//        }
//        let xPos = hue * self.bounds.width
//        return CGPoint(x: xPos, y: yPos)
//    }

    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizer.State.began) {
            let point = gestureRecognizer.location(in: self)
            let color = getColorAtPoint(point: point)
            self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
        }
    }
}
