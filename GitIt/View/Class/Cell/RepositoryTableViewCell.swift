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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
        starsLabel.text = nil
        languageLabel.text = nil
        languageImageView.tintColor = .black
    }

    func configure<Type: Model>(with model: Type) {
        let repository = model as! RepositoryModel
        nameLabel.text = repository.name
        descriptionLabel.text = repository.description
        starsLabel.text = GitIt.formatPoints(num: Double(repository.stars))
        if let language = repository.language {
            if let colorString = LibraryManager.standard.languageColors[language] {
                let color = UIColor(hex: colorString)
                languageImageView.tintColor = color
                languageLabel.text = repository.language
            } else {
                languageImageView.tintColor = .black
                languageLabel.text = "None"
            }
        } else {
            languageImageView.tintColor = .black
            languageLabel.text = "None"
        }
        setNeedsLayout()
    }
    
}
