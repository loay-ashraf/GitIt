//
//  RepositoryTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell, IBTableViewCell {

    static let reuseIdentifier = "RepositoryTableViewCell"
    static var nib: UINib { return UINib(nibName: "RepositoryTableViewCell", bundle: nil) }
    
    @IBOutlet weak var ownerTextView: IconicTextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsNumericView: IconicNumericView!
    @IBOutlet weak var languageTextView: IconicTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ownerTextView.cancelIconLoading()
        nameLabel.text = nil
        descriptionLabel.text = nil
        starsNumericView.numbers = nil
        languageTextView.text = nil
    }

    func configure<Type>(with model: Type) {
        let repository = model as! RepositoryModel
        ownerTextView.loadIcon(at: repository.owner.avatarURL)
        ownerTextView.text = repository.owner.login
        nameLabel.text = repository.name
        if let description = repository.description, !description.isEmpty {
            descriptionLabel.text = repository.description
        } else {
            descriptionLabel.isHidden = true
        }
        starsNumericView.numbers = [ Double(repository.stars) ]
        languageTextView.text = repository.language
        if let language = repository.language {
            if let colorString = LibraryManager.standard.languageColors[language] {
                let color = UIColor(hex: colorString)
                languageTextView.iconTintColor = color
            } else {
                languageTextView.text = nil
            }
        }
        setNeedsLayout()
    }
    
}
