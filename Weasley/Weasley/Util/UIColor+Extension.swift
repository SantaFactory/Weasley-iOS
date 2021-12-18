//
//  UIColor+Extension.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/18.
//

import UIKit

extension UIColor {
    
    var themeColors: [UIColor] {
        return [
            UIColor(named: "magicRed")!,
            UIColor(named: "magicOrange")!,
            UIColor(named: "magicYellow")!,
            UIColor(named: "magicLime")!,
            UIColor(named: "magicGreen")!,
            UIColor(named: "magicBlue")!,
            UIColor(named: "magicPurple")!,
            UIColor(named: "magicPink")!
        ]
    }
    
    static func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return .systemBackground
        }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    
}
