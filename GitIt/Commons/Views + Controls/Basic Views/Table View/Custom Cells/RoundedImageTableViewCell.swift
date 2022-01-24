//
//  RoundedImageTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/10/2021.
//

import UIKit

class RoundedImageTableViewCell: TableViewCell, IBTableViewCell {
    
    override class var reuseIdentifier: String { return String(describing: RoundedImageTableViewCell.self) }
    override class var nib: UINib { return UINib(nibName: String(describing: RoundedImageTableViewCell.self), bundle: nil) }
    
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