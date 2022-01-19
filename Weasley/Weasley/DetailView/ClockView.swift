//
//  ClockView.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/30.
//

import UIKit

class Clock: UIView {
    let x = [1.0, 1.0, 1.0, 0.5, 0, 0, 0, 0.5]
    let y = [0, 0.5, 1.0, 1.0, 1.0, 0.5, 0, 0]
    var startAngle: CGFloat = (-(.pi) / 2)
    var endAngle: CGFloat = 0.0
  
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.size.width / 2.0, rect.size.height / 2.0) - 20
        
        for index in 0..<8 {
            let gradientLayer: CAGradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.themeGreen.cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: x[index], y: y[index])
            gradientLayer.type = .conic
            gradientLayer.frame = rect
            self.layer.addSublayer(gradientLayer)
        }
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: (360 * .pi) / 180, clockwise: true)
        let sliceLayer = CAShapeLayer()
        sliceLayer.frame = rect
        sliceLayer.path = path.cgPath
        self.layer.mask = sliceLayer
    }
}
