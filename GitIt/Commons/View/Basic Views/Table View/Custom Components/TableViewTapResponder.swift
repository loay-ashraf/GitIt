//
//  TableViewTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewTapResponder {
    
    weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    func respondToTap(atRow row: Int) { }
    
}
