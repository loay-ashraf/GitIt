//
//  CommitTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitTableViewCell: TableViewCell, InterfaceBuilderTableViewCell {

    override class var reuseIdentifier: String { return String(describing: CommitTableViewCell.self) }
    override class var nib: UINib { return UINib(nibName: String(describing: CommitTableViewCell.self), bundle: nil) }
    
    @IBOutlet weak var authorTextView: IconicTextView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorTextView.cancelIconLoading()
        authorTextView.text = nil
        messageLabel.text = nil
    }
    
}

struct CommitCellActionProvider {
    
    var openInSafari: () -> Void
    var share: () -> Void
    
}
