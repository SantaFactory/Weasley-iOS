//
//  NeedleView.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/01.
//

import UIKit

class Needle: UILabel {
    
    var totalAngle: CGFloat = 360
    var rotation: CGFloat = 360
    var value = 0 {
        didSet {
            let needlePosition: CGFloat = CGFloat(value) / 360
            let lerpFrom = rotation
            let lerpTo = rotation + totalAngle
            let needleRotation = lerpFrom + (lerpTo - lerpFrom) * needlePosition
            transform = CGAffineTransform(rotationAngle: deg2rad(needleRotation))
        }
    }

    func setUp() {
        textColor = .systemGreen
        font = .systemFont(ofSize: 30, weight: .bold)
        layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
}
