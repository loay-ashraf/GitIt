//
//  SearchResultsDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsDataSource<Type: Model>: TableViewDataSource<Type> {
    
    class func raw() -> TableViewDataSource<Type> {
        switch Type.self {
        case is UserModel.Type: return TableViewDataSourceConstants.userDataSource as! TableViewDataSource<Type>
        case is RepositoryModel.Type: return TableViewDataSourceConstants.repositoryDataSource as! TableViewDataSource<Type>
        case is OrganizationModel.Type: return TableViewDataSourceConstants.organizationDataSource as! TableViewDataSource<Type>
        default: return TableViewDataSource<Type>()
        }
    }
    
}
