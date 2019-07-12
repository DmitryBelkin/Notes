//
//  SelectedColorView.swift
//  Notes
//
//  Created by Dmitry Belkin on 13/07/2019.
//  Copyright © 2019 parameter. All rights reserved.
//

import UIKit

@IBDesignable
class ColorView: UIView {
    @IBInspectable var shapeColor: UIColor = .white
    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var shapePosition: CGPoint = .zero
    @IBInspectable var selected: Bool = false

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        shapeColor.setFill()
        strokeColor.setStroke()

        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1

//        нужно залить вьюху цветом, но почему-то на старте она не заливается? а заливается лишь после тапа на любую из них
//        поэтому пока впилен drawBorders, который задает границы заливки
//        self.backgroundColor = shapeColor
        drawBorders(in: CGRect(origin: shapePosition, size: rect.size))

        if selected {
            let delta = CGFloat(5)
            drawFlag(in: CGRect(
                x: rect.width/2 + delta,
                y: delta,
                width : rect.width  / 2 - 2 * delta,
                height: rect.height / 2 - 2 * delta))
        }
    }

    private func drawBorders(in rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
    }

    private func drawFlag(in rect: CGRect) {
        let circle = UIBezierPath(ovalIn: rect)
        circle.lineWidth = 2
        circle.stroke()

        // много магического
        let checkmark = UIBezierPath()
        checkmark.move   (to: CGPoint(x: rect.minX + rect.width/3, y: rect.height/1.5))
        checkmark.addLine(to: CGPoint(x: rect.minX + rect.width/2, y: rect.height))
        checkmark.addLine(to: CGPoint(x: rect.minX + rect.width * 0.65, y: rect.height*0.5))
        checkmark.stroke()
    }
}
