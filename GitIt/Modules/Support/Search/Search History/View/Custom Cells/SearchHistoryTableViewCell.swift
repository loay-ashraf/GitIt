//
//  SearchHistoryTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/11/2021.
//

import UIKit

class SearchHistoryTableViewCell: TableViewCell, InterfaceBuilderTableViewCell {
    
    override class var reuseIdentifier: String { return String(describing: SearchHistoryTableViewCell.self) }
    override class var nib: UINib { return UINib(nibName: String(describing: SearchHistoryTableViewCell.self), bundle: nil) }
    
    @IBOutlet weak var historyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        historyLabel.text = nil
    }
    
}
