//
//  UserCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewCellConfigurator: TableViewCellConfigurator {
    
    func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? RoundedImageTableViewCell, let item = item as? UserModel {
            cell.nameLabel.text = item.login
            cell.iconImageView.load(at: item.avatarURL)
            cell.setNeedsLayout()
        }
    }
    
}