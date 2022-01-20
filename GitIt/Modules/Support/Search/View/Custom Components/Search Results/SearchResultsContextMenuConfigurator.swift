//
//  SearchResultsContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsContextMenuConfigurator<Type>: TableViewContextMenuConfigurator {
    
    var rawConfigurator: TableViewContextMenuConfigurator!
    
    override init() {
        super.init()
        switch Type.self {
        case is UserModel.Type: rawConfigurator = UserTableViewContextMenuConfigurator()
        case is RepositoryModel.Type: rawConfigurator = RepositoryTableViewContextMenuConfigurator()
        case is OrganizationModel.Type: rawConfigurator = OrganizationTableViewContextMenuConfigurator()
        default: break
        }
    }
    
    override func configure<Type>(with item: Type) -> UIContextMenuConfiguration {
        rawConfigurator.configure(with: item)
    }
    
}
