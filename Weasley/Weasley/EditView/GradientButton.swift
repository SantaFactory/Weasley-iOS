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
        gradientLayer.colors = [UIColor.systemPink.withAlphaComponent(0.8).cgColor, UIColor.systemPink.withAlphaComponent(0.9).cgColor,  UIColor.systemPink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.4, y: 1.6)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
