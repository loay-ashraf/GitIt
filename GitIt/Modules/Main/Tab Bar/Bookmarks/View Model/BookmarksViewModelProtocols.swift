//
//  BookmarksViewModelProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol BookmarksViewModel: AnyObject {
    
    associatedtype TableCellViewModelType: TableCellViewModel
    
    var cellViewModels: Array<TableCellViewModelType> { get }
    var count: Int { get }
    var isEmpty: Bool { get }
    
    func load(then handler: @escaping LoadingHandler)
    func unBookmarkAction()

}

extension BookmarksViewModel {
    
    // MARK: - Properties
    
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    
}
