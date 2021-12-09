//
//  HistoryTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/11/2021.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "HistoryTableViewCell"
    static var nib: UINib { return UINib(nibName: "HistoryTableViewCell", bundle: nil) }
    
    @IBOutlet weak var recentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recentsLabel.text = nil
    }
    
    func configure(text: String) {
        recentsLabel.text = text
        setNeedsLayout()
    }
    
}