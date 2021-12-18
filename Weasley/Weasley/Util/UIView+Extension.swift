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
    
    var hideAnimator: UIViewPropertyAnimator {
        return UIViewPropertyAnimator
            .runningPropertyAnimator(
                withDuration: 1.5,
                delay: 5.0
            ) {
                self.alpha = 0
            }
    }
    
    func animateToHide() {
        self.alpha = 1
        self.hideAnimator.startAnimation()
    }
 
}
