//
//  OrganizationDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewDelegate: TableViewDelegate<OrganizationModel> {
    
    override init() {
        super.init()
        model = List<OrganizationModel>()
        detailViewControllerPresenter = OrganizationTableViewDetailPresenter()
        contextMenuConfigurator = OrganizationTableViewContextMenuConfigurator()
    }
    
}
