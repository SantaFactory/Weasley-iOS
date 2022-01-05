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
        self.viewModel.place = "work"
        self.nextButton.setTitle("Done", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
