//
//  TableViewSwipeResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class TableViewSwipeResponder {
    
    weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func respondToSwipe(editingStyle: UITableViewCell.EditingStyle, atRow row: Int) { }
    
}

