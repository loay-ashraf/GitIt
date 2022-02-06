//
//  SearchCoordinatorProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/02/2022.
//

import Foundation

protocol SearchModule: AnyObject {
    
    associatedtype SearchHistoryViewModelType: SearchHistoryViewModel
    associatedtype SearchResultsViewModelType: SearchResultsViewModel
    
    static var searchBarPlaceholder: String { get }
    
}

extension SearchModule {
    
    static var searchBarPlaceholder: String { return ViewConstants.SearchBar.general }
    
}
