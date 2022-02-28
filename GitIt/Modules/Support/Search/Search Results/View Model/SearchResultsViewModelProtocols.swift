//
//  SearchResultsViewModelProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchResultsViewModel: WebServiceSearchTableViewModel {
    
    func toggleBookmark(atRow row: Int)
    
}

extension SearchResultsViewModel {
    
    // MARK: - View Actions
    
    func toggleBookmark(atRow row: Int) {
        items[row].toggleBookmark()
    }
    
}
