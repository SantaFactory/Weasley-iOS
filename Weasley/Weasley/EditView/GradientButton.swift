//
//  SetButton.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/07.
//

import UIKit

class GradientButton: UIButton {

    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.type = .radial
        gradientLayer.colors = [UIColor.systemPink.withAlphaComponent(0.7).cgColor, UIColor.systemPink.cgColor]
        gradientLayer.locations = [0.9]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.95, y: 1.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
