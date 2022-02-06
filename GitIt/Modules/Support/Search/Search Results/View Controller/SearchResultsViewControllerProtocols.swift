//
//  SearchResultsViewControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchResultsDelegate: AnyObject {
    
    func addObject<T: TableCellViewModel>(with cellViewModel: T)
    func dismissResultsKeyboard()
    
}
