//
//  SettingTableViewCell.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/17.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
   
    static let reuseID = "SettingTableViewCellReuseID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
