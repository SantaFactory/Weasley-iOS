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
        self.nextButton.setTitle("Done".localized, for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.place = "work"
        self.titleLabel.text = "Mark work location".localized
        self.descriptionLabel.text = "Pick a location for your work location. You can always change it later.".localized
    }
    
}
