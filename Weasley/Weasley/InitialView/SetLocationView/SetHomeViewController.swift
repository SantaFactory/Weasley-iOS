//
//  SetHomeViewController.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/15.
//

import UIKit

class SetHomeViewController: SetLocationViewController {

    override func loadView() {
        super.loadView()
        self.destinationVC = SetSchoolViewController()
        self.nextButton.setTitle("Next", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.place = "home"
        self.titleLabel.text = "Mark \(viewModel.place ?? "") location"
    }
    
}
