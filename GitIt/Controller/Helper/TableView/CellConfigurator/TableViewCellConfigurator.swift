//
//  TableViewCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
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

class OrganizationTableViewCellConfigurator: TableViewCellConfigurator {
    
    func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? RoundedImageTableViewCell, let item = item as? OrganizationModel {
            cell.nameLabel.text = item.login
            cell.iconImageView.load(at: item.avatarURL)
            cell.setNeedsLayout()
        }
    }
    
}

class CommitTableViewCellConfigurator: TableViewCellConfigurator {
    
    func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? CommitTableViewCell, let item = item as? CommitModel {
            if let author = item.author {
                cell.authorTextView.loadIcon(at: author.avatarURL)
                cell.authorTextView.text = author.login
            } else {
                cell.authorTextView.text = nil
            }
            cell.messageLabel.text = item.message
            cell.setNeedsLayout()
        }
    }
    
}

class HistoryTableViewCellConfigurator: TableViewCellConfigurator {
    
    func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? HistoryTableViewCell, let item = item as? String {
            cell.historyLabel.text = item
            cell.setNeedsLayout()
        }
    }
    
}

protocol TableViewCellConfigurator {
    func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type)
}
