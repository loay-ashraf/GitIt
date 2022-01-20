//
//  OrganizationTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewTapResponder: TableViewTapResponder {
    
    init() {
        super.init(viewControllerClass: OrganizationDetailViewController.self)
    }
    
}

class OrganizationCollectionViewTapResponder: CollectionViewTapResponder {
    
    init() {
        super.init(viewControllerClass: OrganizationDetailViewController.self)
    }
    
}
