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
 
}
