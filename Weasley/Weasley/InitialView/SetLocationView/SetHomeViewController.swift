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
        self.nextButton.setTitle("Next".localized, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.place = "home"
        self.titleLabel.text = "Mark home location".localized
        self.descriptionLabel.text = "Pick a location for your home location. You can always change it later.".localized
    }
    
}
