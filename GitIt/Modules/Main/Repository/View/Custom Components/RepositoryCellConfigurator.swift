//
//  RepositoryCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewCellConfigurator: TableViewCellConfigurator {
    
    func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? RepositoryTableViewCell, let item = item as? RepositoryModel {
            cell.ownerTextView.loadIcon(at: item.owner.avatarURL)
            cell.ownerTextView.text = item.owner.login
            cell.nameLabel.text = item.name
            if let description = item.description, !description.isEmpty {
                cell.descriptionLabel.text = item.description
            } else {
                cell.descriptionLabel.isHidden = true
            }
            cell.starsNumericView.numbers = [ Double(item.stars) ]
            cell.languageTextView.text = item.language
            if let language = item.language, let languageColors = cell.languageColors {
                if let colorString = languageColors[language] {
                    let color = UIColor(hex: colorString)
                    cell.languageTextView.iconTintColor = color
                } else {
                    cell.languageTextView.text = nil
                }
            }
            cell.setNeedsLayout()
        }
    }
    
}
