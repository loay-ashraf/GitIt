//
//  BookmarksViewModelProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol BookmarksViewModel: DataPersistenceTableViewModel where LogicControllerType: BookmarksLogicController {
    
    var count: Int { get }
    var isEmpty: Bool { get }
    
    func toggleBookmark(atRow row: Int)

}

extension BookmarksViewModel {
    
    // MARK: - Properties
    
    var count: Int { return cellViewModels.count }
    var isEmpty: Bool { return cellViewModels.isEmpty }
    
    // MARK: - View Actions
    
    func toggleBookmark(atRow row: Int) {
        cellViewModels[row].toggleBookmark()
    }
    
    // MARK: - View Model Manipulationn Methods
    
    func add(cellViewModel: TableCellViewModelType) {
        return
    }
    
    func delete(cellViewModel: TableCellViewModelType) {
        let model = ModelType(from: cellViewModel as! ModelType.TableCellViewModelType)
        logicController.delete(model: model as! LogicControllerType.ModelType)
        synchronize()
    }
    
    func clear() {
        logicController.clear()
        synchronize()
    }
    
    // MARK: - View Model Synchronize Method
    
    func synchronize() {
        logicController.synchronize()
        let objectItems = logicController.model
        cellViewModels = objectItems.map { return TableCellViewModelType(from: $0 as! TableCellViewModelType.ModelType) }
    }
    
}
