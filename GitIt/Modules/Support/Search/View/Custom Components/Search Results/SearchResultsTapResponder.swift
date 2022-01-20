//
//  SearchResultsTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsTapResponder<Type>: TableViewTapResponder {
    
    var rawTapResponder: TableViewTapResponder?
    weak var resultsDelegate: ResultsDelegate?
    
    init(delegate: ResultsDelegate) {
        self.resultsDelegate = delegate
        switch Type.self {
        case is UserModel.Type: rawTapResponder = UserTableViewTapResponder()
        case is RepositoryModel.Type: rawTapResponder = RepositoryTableViewTapResponder()
        case is OrganizationModel.Type: rawTapResponder = OrganizationTableViewTapResponder()
        default: break
        }
    }
    
    override func respondToTap<Type>(with item: Type) {
        resultsDelegate?.addModel(with: item)
        rawTapResponder?.respondToTap(with: item)
    }
    
}
