//
//  CommitCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewCellConfigurator: TableViewCellConfigurator {
    
    override func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? CommitTableViewCell, let item = item as? CommitCellViewModel {
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
