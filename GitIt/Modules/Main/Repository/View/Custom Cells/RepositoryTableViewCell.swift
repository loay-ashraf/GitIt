//
//  RepositoryTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import UIKit

class RepositoryTableViewCell: TableViewCell, IBTableViewCell {

    override class var reuseIdentifier: String { return String(describing: RepositoryTableViewCell.self) }
    override class var nib: UINib { return UINib(nibName: String(describing: RepositoryTableViewCell.self), bundle: nil) }
    
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
    
}
