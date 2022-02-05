//
//  SearchCoordinatorProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/02/2022.
//

import Foundation

protocol SearchStackType: AnyObject {
    
    associatedtype SearchResultsViewModelType: SearchResultsViewModel
    associatedtype SearchHistoryViewModelType: SearchHistoryViewModel
    
    static var context: SearchContext { get }
    
}
