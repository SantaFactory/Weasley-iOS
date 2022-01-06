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
        self.nextButton.setTitle("Done", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.place = "work"
        self.titleLabel.text = "Mark \(viewModel.place ?? "") location"
    }
    
}
