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
    
    @IBOutlet weak var avatarImageView: SFImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.cornerRadius = 16.0
        avatarImageView.cornerCurve = .continuous
        avatarImageView.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        avatarImageView.cancel()
        loginLabel.text = nil
        messageLabel.text = nil
    }

    func configure<Type: Model>(with model: Type) {
        let commit = model as! CommitModel
        if commit.author != nil {
            avatarImageView.load(at: commit.author!.avatarURL)
            loginLabel.text = commit.author!.login
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
            loginLabel.text = "No author found"
        }
        messageLabel.text = commit.message
        setNeedsLayout()
    }
    
}
