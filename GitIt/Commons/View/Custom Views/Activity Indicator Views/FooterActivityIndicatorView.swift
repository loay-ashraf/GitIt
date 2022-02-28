//
//  FooterActivityIndicatorView.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/12/2021.
//

import UIKit

class FooterActivityIndicatorView: UIView {
    
    private weak var parentTableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    class func instanceFromNib() -> FooterActivityIndicatorView {
        let bundle = Bundle(for: FooterActivityIndicatorView.self)
        let view = UINib(nibName: "FooterActivityIndicatorView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! FooterActivityIndicatorView
        return view
    }
    
    func add(to tableView: UITableView) {
        parentTableView = tableView
    }
    
    func show() {
        parentTableView.tableFooterView = self
        spinner.startAnimating()
    }
    
    func hide() {
        if let parentTableView = self.parentTableView {
            parentTableView.tableFooterView = UIView()
            self.spinner.stopAnimating()
        }
    }

}
