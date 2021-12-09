//
//  ClockView.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/30.
//

import UIKit

class Clock: UIView {
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    var startAngle: CGFloat = (-(.pi) / 2)
    var endAngle: CGFloat = 0.0
    let colors = [
        UIColor(named: "magicRed")!,
        UIColor(named: "magicOrange")!,
        UIColor(named: "magicYellow")!,
        UIColor(named: "magicLime")!,
        UIColor(named: "magicGreen")!,
        UIColor(named: "magicBlue")!,
        UIColor(named: "magicPurple")!,
        UIColor(named: "magicPink")!
    ]
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.size.width / 2.0, rect.size.height / 2.0) - 20
        
        let path = UIBezierPath()
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: (360 * .pi) / 180,
            clockwise: true
        )
        self.gradientLayer.colors = colors.map{ $0.withAlphaComponent(0.6).cgColor }
        gradientLayer.frame = rect
        self.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        self.gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        self.gradientLayer.type = .conic
        
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradientLayer.mask = shapeMask
        self.layer.addSublayer(gradientLayer)
        
        for index in 0..<8 {
            let path = UIBezierPath()
            endAngle = (1 / 8) * (.pi * 2)
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: startAngle + endAngle,
                        clockwise: true
            )
            colors[index].withAlphaComponent(0.2).set()
            path.fill()
            path.close()
            startAngle += endAngle
        }
    }
}
