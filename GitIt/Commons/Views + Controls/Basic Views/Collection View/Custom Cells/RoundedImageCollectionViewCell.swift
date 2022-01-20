//
//  RoundedImageCollectionViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/11/2021.
//

import UIKit

class RoundedImageCollectionViewCell: CollectionViewCell, IBCollectionViewCell {

    override class var reuseIdentifier: String { return String(describing: RoundedImageCollectionViewCell.self) }
    override class var nib: UINib? { return UINib(nibName: String(describing: RoundedImageCollectionViewCell.self), bundle: nil) }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: SFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.cornerRadius = 32.0
        iconImageView.cornerCurve = .continuous
        iconImageView.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        iconImageView.image = nil
        iconImageView.cancel()
    }

}
