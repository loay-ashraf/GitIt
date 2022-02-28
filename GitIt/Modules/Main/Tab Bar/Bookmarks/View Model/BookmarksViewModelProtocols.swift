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
    func bindToModel()

}

extension BookmarksViewModel {
    
    // MARK: - Properties
    
    var count: Int { return cellViewModelArray.count }
    var isEmpty: Bool { return cellViewModelArray.isEmpty }
    
    // MARK: - View Actions
    
    func toggleBookmark(atRow row: Int) {
        cellViewModelArray[row].toggleBookmark()
    }
    
    // MARK: - View Model Manipulationn Methods
    
    func add(cellViewModel: TableCellViewModelType) {
        return
    }
    
    func delete(cellViewModel: TableCellViewModelType) {
        let model = ModelType(from: cellViewModel as! ModelType.TableCellViewModelType)
        logicController.delete(model: model as! LogicControllerType.ModelType)
    }
    
    func clear() {
        logicController.clear()
    }
    
}
