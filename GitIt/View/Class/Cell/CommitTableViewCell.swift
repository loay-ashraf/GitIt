//
//  CommitTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitTableViewCell: UITableViewCell, IBTableViewCell {

    static let reuseIdentifier = "CommitTableViewCell"
    static var nib: UINib { return UINib(nibName: "CommitTableViewCell", bundle: nil) }
    
    @IBOutlet weak var authorTextView: IconicTextView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorTextView.cancelIconLoading()
        authorTextView.text = nil
        messageLabel.text = nil
    }
    
}
