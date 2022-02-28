//
//  OrganizationTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewTapResponder: TableViewTapResponder {
    
    override func respondToTap(atRow row: Int) {
        if let viewController = viewController as? OrganizationViewController {
            viewController.showDetail(atRow: row)
        }
    }
    
}

class OrganizationCollectionViewTapResponder: CollectionViewTapResponder {
    
    override func respondToTap(atItem item: Int) {
        if let viewController = viewController as? OrganizationViewController {
            viewController.showDetail(atRow: item)
        }
    }
    
}
