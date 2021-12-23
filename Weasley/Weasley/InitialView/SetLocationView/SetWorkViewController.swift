//
//  SetWorkViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/16.
//

import UIKit

class SetWorkViewController: SetLocationViewController {
    
    override func loadView() {
        super.loadView()
        self.destinationVC = FinishInitialViewController()
        self.viewModel?.place = "work"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
