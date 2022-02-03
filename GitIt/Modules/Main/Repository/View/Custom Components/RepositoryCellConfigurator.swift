//
//  RepositoryCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewCellConfigurator: TableViewCellConfigurator {
    
    let bundleHelper = DataManager.standard.bundleHelper
    var languageColors: [String:String]? {
        get {
            if let languageColors = try? bundleHelper.loadResource(title: "LanguageColors", withExtension: "json").get() {
                let dict = try? JSONSerialization.jsonObject(with: languageColors, options: [])
                return dict as? [String:String]
            }
           return nil
        }
    }
    
    override func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? RepositoryTableViewCell, let item = item as? RepositoryCellViewModel {
            cell.ownerTextView.loadIcon(at: item.owner.avatarURL)
            cell.ownerTextView.text = item.owner.login
            cell.nameLabel.text = item.name
            if let description = item.description, !description.isEmpty {
                cell.descriptionLabel.text = item.description
            } else {
                cell.descriptionLabel.isHidden = true
            }
            cell.starsNumericView.numbers = [ Double(item.stargazers) ]
            cell.languageTextView.text = item.language
            if let language = item.language, let languageColors = languageColors {
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

class RepositoryCollectionViewCellConfigurator: CollectionViewCellConfigurator {
    
    override func configure<Type>(_ cell: UICollectionViewCell, forDisplaying item: Type) {
        if let cell = cell as? RoundedImageCollectionViewCell, let item = item as? RepositoryModel {
            cell.nameLabel.text = item.name
            cell.iconImageView.load(at: item.owner.avatarURL)
            cell.setNeedsLayout()
        }
    }
    
}
