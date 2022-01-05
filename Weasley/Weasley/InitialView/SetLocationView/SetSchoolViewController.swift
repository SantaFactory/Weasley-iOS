//
//  SetSchoolViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/15.
//

import UIKit

class SetSchoolViewController: SetLocationViewController {

    override func loadView() {
        super.loadView()
        self.destinationVC = SetWorkViewController()
        self.viewModel.place = "school"
        self.nextButton.setTitle("Next", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
