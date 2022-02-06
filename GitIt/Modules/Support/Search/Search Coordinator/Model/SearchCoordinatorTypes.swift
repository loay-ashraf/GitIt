//
//  SearchCoordinatorTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

enum SearchContext {
    
    case users
    case repositories
    case organizations
    
}

enum SearchViewState {
    
    case idle
    case searching
    
}
