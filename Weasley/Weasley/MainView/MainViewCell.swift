//
//  MainViewCell.swift
//  Weasley
//
//  Created by Doyoung on 2021/12/02.
//

import UIKit
import SnapKit

class GroupCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(groupNameLabel)
        groupNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        contentView.layer.cornerRadius = contentView.frame.size.height / 2
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    lazy var groupNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}

class MemberCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(nameLabel)
//        nameLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.bottom.equalToSuperview()
//            make.trailing.equalToSuperview()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
}
