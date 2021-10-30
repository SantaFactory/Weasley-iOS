//
//  ClockView.swift
//  Weasley
//
//  Created by Doyoung on 2021/10/30.
//

import UIKit

class ClockView: UIView {
    
    var startAngle: CGFloat = (-(.pi) / 2)
    var endAngle: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        let radius = min(rect.size.width / 2.0, rect.size.height / 2.0)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        for value in 1...8 {
            let path = UIBezierPath()
            path.move(to: center)
            endAngle = (CGFloat(value) / 8) * (.pi * 2)
            path.addArc(withCenter: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: startAngle + endAngle,
                        clockwise: true
            )
            value % 2 == 0 ? UIColor.blue.withAlphaComponent(0.3).set() : UIColor.yellow.withAlphaComponent(0.3).set()
            path.fill()
            path.close()
            startAngle = endAngle
        }
    }
    
}
