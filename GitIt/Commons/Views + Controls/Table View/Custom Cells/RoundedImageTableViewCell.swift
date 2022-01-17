//
//  RoundedImageTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/10/2021.
//

import UIKit

class RoundedImageTableViewCell: UITableViewCell, IBTableViewCell {
    
    static let reuseIdentifier = "RoundedImageTableViewCell"
    static var nib: UINib { return UINib(nibName: "RoundedImageTableViewCell", bundle: nil) }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: SFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.cornerRadius = 32.0
        iconImageView.cornerCurve = .continuous
        iconImageView.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        iconImageView.image = nil
        iconImageView.cancel()
    }

}
