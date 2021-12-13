//
//  UIView+Animation.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/12.
//

import UIKit

extension UIView {

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
