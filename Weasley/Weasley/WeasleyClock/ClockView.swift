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
    
    override func draw(_ rect: CGRect) {
        let radius = min(rect.size.width / 2.0, rect.size.height / 2.0) - 20
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let background = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: (360 * .pi) / 180,
            clockwise: true
        )
        UIColor.black.set()
        background.fill()
        let whole = UIBezierPath(
            arcCenter: center,
            radius: radius * 0.8,
            startAngle: 0,
            endAngle: (360 * .pi) / 180,
            clockwise: true
        )
        UIColor.secondarySystemBackground.set()
        whole.fill()
        
        for _ in 1...8 {
            endAngle = (1 / 8) * (.pi * 2)
            
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: startAngle + endAngle,
                        clockwise: true
            )
            UIColor.clear.set()
            path.fill()
            path.close()
            
            UIColor.black.set()
            path.lineWidth = 7
            path.stroke()
            startAngle += endAngle
        }
        
        let semiCircle = UIBezierPath(
            arcCenter: center,
            radius: radius * 0.6,
            startAngle: 0,
            endAngle: (360 * .pi) / 180,
            clockwise: true
        )
        UIColor.secondarySystemBackground.set()
        semiCircle.fill()
    }
    
}
