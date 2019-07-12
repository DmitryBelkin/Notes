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
    weak internal var delegate: HSBColorPickerDelegate?
    var brightnessValue = Float(0.5)
    var targetRect = UIScreen.main.bounds
    var currentPoint: CGPoint? {
        didSet {
            _ = self.layer.sublayers?.popLast()
            drawPointer(in: currentPoint!)
        }
    }

    func drawPointer(in point: CGPoint) {
        let radius = CGFloat(10)
        let rect = CGRect(x: point.x - radius,
                          y: point.y - radius,
                          width : CGFloat(2 * radius),
                          height: CGFloat(2 * radius))
        let circle = UIBezierPath(ovalIn: rect)
        circle.lineWidth = 1

        let lineLength = CGFloat(radius*0.6)
        let lines = UIBezierPath()
        lines.move(to: CGPoint(x: rect.midX, y: rect.minY))
        lines.addLine(to: CGPoint(x: rect.midX, y: rect.minY - lineLength))

        lines.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        lines.addLine(to: CGPoint(x: rect.maxX + lineLength, y: rect.midY))

        lines.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        lines.addLine(to: CGPoint(x: rect.midX, y: rect.maxY + lineLength))

        lines.move(to: CGPoint(x: rect.minX, y: rect.midY))
        lines.addLine(to: CGPoint(x: rect.minX - lineLength, y: rect.midY))

        circle.append(lines)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circle.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1

        self.layer.addSublayer(shapeLayer)
    }

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
        let hue = roundedPoint.x / targetRect.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    func getPointForColor(color: UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)

        return CGPoint(x: hue * targetRect.width, y: targetRect.height * (1 - saturation))
    }

    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
    }
}
