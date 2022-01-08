//
//  HistoryCollectionViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/11/2021.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell, IBCollectionViewCell {

    static let reuseIdentifier = "HistoryCollectionViewCell"
    static var nib: UINib { return UINib(nibName: "HistoryCollectionViewCell", bundle: nil) }
    
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var recentImageView: SFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recentImageView.cornerRadius = 32.0
        recentImageView.cornerCurve = .continuous
        recentImageView.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recentLabel.text = nil
        recentImageView.image = nil
        recentImageView.cancel()
    }
    
    func configure<Type>(with model: Type) {
        switch model.self {
        case is UserModel: recentLabel.text = (model as! UserModel).login
                           recentImageView.load(at: (model as! UserModel).avatarURL)
        case is RepositoryModel: recentLabel.text = (model as! RepositoryModel).name
            recentImageView.load(at: (model as! RepositoryModel).owner.avatarURL)
        case is OrganizationModel: recentLabel.text = (model as! OrganizationModel).login
            recentImageView.load(at: (model as! OrganizationModel).avatarURL)
        default: recentLabel.text = ""
                 recentImageView.image = UIImage(systemName: "globe")
        }
        setNeedsLayout()
    }

}