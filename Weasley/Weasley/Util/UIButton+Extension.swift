//
//  UIButton+Extension.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/19.
//

import UIKit

extension UIButton {
    
    func defaultAction() {
        self.addTarget(self, action: #selector(tapButton), for: .touchDown)
        self.addTarget(self, action: #selector(cancelTap), for: .touchDragOutside)
    }
    
    func enableStatus(_ status: Bool) {
        self.isEnabled = status
        if self.isEnabled {
            self.alpha = 1
        } else {
            self.alpha = 0.5
        }
    }
    
    @objc func tapButton() {
        self.alpha = 0.5
    }
    
    @objc func cancelTap() {
        self.alpha = 1.0
    }
}
