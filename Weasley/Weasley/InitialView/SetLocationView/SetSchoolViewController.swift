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
        self.nextButton.setTitle("Next".localized, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.place = "school"
        self.titleLabel.text = "Mark school location".localized
        self.descriptionLabel.text = "Pick a location for your school location. You can always change it later.".localized
    }
    
}
