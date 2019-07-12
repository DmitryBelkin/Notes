//
//  PaletteColorView.swift
//  Notes
//
//  Created by Dmitry Belkin on 15/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

@IBDesignable
class PaletteColorView: UIView {
    @IBInspectable var shapeColor: UIColor = .white
    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var shapePosition: CGPoint = .zero
    @IBInspectable var shapeSize: CGSize = CGSize(width: 40, height: 40)
    @IBInspectable var selected: Bool = false

    @IBInspectable var elementSize: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        strokeColor.setStroke()

        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1

        if selected {
            let delta = CGFloat(exactly: 7)!
            drawFlag(in: CGRect(x: shapeSize.width/2 + delta, y: delta, width: shapeSize.width/2 - 2*delta, height: shapeSize.height/2 - 2*delta))
        }

        let context = UIGraphicsGetCurrentContext()
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            let saturation = CGFloat(rect.height - y) / rect.height
            let brightness = CGFloat(1)
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }

    private func drawFlag(in rect: CGRect) {
        let circle = UIBezierPath(ovalIn: rect)
        circle.lineWidth = 2
        circle.stroke()
//        circle.fill() // ?

        let checkmark = UIBezierPath()
        checkmark.move(to: CGPoint(x: rect.minX + rect.width/3, y: rect.height/1.5))
        checkmark.addLine(to: CGPoint(x: rect.minX + rect.width/2, y: rect.height))
        checkmark.addLine(to: CGPoint(x: rect.minX + rect.width * 0.65, y: rect.height*0.5))
        checkmark.stroke()
    }
}

