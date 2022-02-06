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
    
    static var context: SearchContext { get }
    
}
