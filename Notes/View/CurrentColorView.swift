//
//  CurrentColorView.swift
//  Notes
//
//  Created by Dmitry Belkin on 14/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

@IBDesignable
//recommend to rename to ColorSelectorView
class CurrentColorView: UIView {
    @IBInspectable var fillColor: UIColor = .white
    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var hexFillColorValue: String = "#ffffff"

    private let cornerRadius: CGFloat = 10
    private let fillColorPart: CGFloat = 0.75

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 80, height: 80)
    }
//why not to use just an image view and create filled image with selected color in the same way?
//In such case you will delete this file and will have less code which you need to support
//I never used overriding of draw, only if it is not a requirement
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        strokeColor.setStroke()
        let roundRect = UIBezierPath(roundedRect: rect, cornerRadius: 10)

        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect // чо я делал... не помню
        maskLayer.path = roundRect.cgPath
        self.layer.mask = maskLayer

        self.layer.borderColor = strokeColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = cornerRadius

        fillColor.setFill()
        drawUpPathForColorFill(inRect: rect)

        UIColor.white.setFill()
        drawBottomPathForColorFill(inRect: rect)

        let rectForText = CGRect(
            x: rect.minX,
            y: rect.minY + 0.77 * rect.height, // зависимость от размера кегеля
            width: rect.width,
            height: 0.4 * rect.height) // зависимость от размера кегеля

        drawMyText(hexFillColorValue, inRect: rectForText)
    }

    func drawMyText(_ myText: String, inRect: CGRect){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14.0),
            .foregroundColor: UIColor.black,
            .backgroundColor: UIColor.white
        ]

        let attributedString = NSAttributedString(string: myText, attributes: attributes)

        attributedString.draw(in: inRect)
    }

    func drawUpPathForColorFill(inRect: CGRect) {
        let  leftTopCorner = CGPoint(x: inRect.minX + cornerRadius, y: inRect.minY + cornerRadius)
        let rightTopCorner = CGPoint(x: inRect.maxX - cornerRadius, y: inRect.minY + cornerRadius)

        let path = UIBezierPath()
        path.move   (to: CGPoint(x: inRect.minX + cornerRadius, y: inRect.minY))
        path.addLine(to: CGPoint(x: inRect.maxX - cornerRadius, y: inRect.minY))
        path.addArc(withCenter: rightTopCorner, radius: cornerRadius, startAngle: .pi/2, endAngle: 0, clockwise: true)
        path.addLine(to: CGPoint(x: inRect.maxX, y: inRect.height * fillColorPart))
        path.addLine(to: CGPoint(x: inRect.minX, y: inRect.height * fillColorPart))
        path.addLine(to: CGPoint(x: inRect.minX, y: inRect.minY + cornerRadius))
        path.addArc(withCenter: leftTopCorner, radius: cornerRadius, startAngle: .pi, endAngle: .pi/2, clockwise: true)
        path.stroke()
        path.fill()
    }

    func drawBottomPathForColorFill(inRect: CGRect) {
        let  leftBottomCorner = CGPoint(x: inRect.minX + cornerRadius, y: inRect.maxY - cornerRadius)
        let rightBottomCorner = CGPoint(x: inRect.maxX - cornerRadius, y: inRect.maxY - cornerRadius)

        let path = UIBezierPath()
        path.move   (to: CGPoint(x: inRect.minX, y: inRect.height * fillColorPart))
        path.addLine(to: CGPoint(x: inRect.maxX, y: inRect.height * fillColorPart))
        path.addLine(to: CGPoint(x: inRect.maxX, y: inRect.maxY - cornerRadius))
        path.addArc(withCenter: rightBottomCorner, radius: cornerRadius, startAngle: 0, endAngle: .pi/2, clockwise: true)
        path.addLine(to: CGPoint(x: inRect.minX + cornerRadius, y: inRect.maxY))
        path.addArc(withCenter: leftBottomCorner, radius: cornerRadius, startAngle: .pi*1.5, endAngle: .pi, clockwise: true)
        path.addLine(to: CGPoint(x: inRect.minX, y: inRect.height * fillColorPart))
        path.stroke()
        path.fill()
    }

}
