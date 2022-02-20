//
//  CollectionViewTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CollectionViewTapResponder {

    weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    func respondToTap(atItem item: Int) { }
    
}
