//
//  CAGradientLayer+Extension.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/18.
//

import UIKit

extension CAGradientLayer {
    
    func getGradientLayer(
        colors: [UIColor],
        alpha: CGFloat,
        frame: CGRect,
        startPoint: CGPoint,
        endPoint: CGPoint) {
            self.frame = frame
            self.colors = colors.map {
                $0.withAlphaComponent(alpha).cgColor
            }
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
}
