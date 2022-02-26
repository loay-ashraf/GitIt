//
//  FooterErrorView.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import UIKit

class FooterErrorView: UIView {

    private var action: (() -> Void)!
    
    private weak var parentTableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    class func instanceFromNib() -> FooterErrorView {
        let bundle = Bundle(for: FooterErrorView.self)
        let view = UINib(nibName: "FooterErrorView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! FooterErrorView
        view.configureView()
        return view
    }
    
    @IBAction func tryAgain (_ sender: UIButton) {
        action()
    }
    
    private func configureView() {
        actionButton.cornerRadius = 16.0
        actionButton.cornerCurve  = .continuous
        actionButton.masksToBounds = true
    }
    
    func configureAction(action: @escaping () -> Void) {
        self.action = action
    }
    
    func add(to tableView: UITableView) {
        parentTableView = tableView
    }
    
    func show(with errorModel: ErrorViewModel?) {
        imageView.image = errorModel?.image
        titleLabel.text = errorModel?.title
        parentTableView.tableFooterView = self
    }
    
    func hide() {
        if let parentTableView = self.parentTableView {
            parentTableView.tableFooterView = UIView()
        }
    }

}
