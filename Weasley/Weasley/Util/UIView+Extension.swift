//
//  View+SafeArea.swift
//  Weasley
//
//  Created by Doyoung on 2021/11/01.
//

import UIKit
import SnapKit

extension UIView {
    
    var safeArea: ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }
    
    func rounded(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func shadows(color: UIColor) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 9
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
    }
    
    var hideAnimator: UIViewPropertyAnimator {
        return UIViewPropertyAnimator
            .runningPropertyAnimator(
                withDuration: 1.5,
                delay: 5.0
            ) {
                self.alpha = 0
            }
    }
    
    func animateToHide(showAlpha alpha: Double) {
        self.alpha = alpha
        self.hideAnimator.startAnimation()
    }
 
}
