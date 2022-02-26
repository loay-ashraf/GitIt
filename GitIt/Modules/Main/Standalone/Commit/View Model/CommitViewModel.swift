//
//  CommitViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class CommitViewModel: WebServicePlainTableViewModel {
    
    // MARK: - Properties
    
    typealias TableCellViewModelType = CommitCellViewModel
    
    var logicController: CommitLogicController
    var cellViewModels = Observable<List<CommitCellViewModel>>()
    
    // MARK: - Initialization
    
    init(repositoryFullName: String) {
        logicController = CommitLogicController(repositoryFullName: repositoryFullName)
        bindToModel()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] modelList in
            if let modelList = modelList {
                let modelItems = modelList.items
                self?.cellViewModelList.items = modelItems.map { return CommitCellViewModel(from: $0) }
                self?.cellViewModelList.currentPage = modelList.currentPage
                self?.cellViewModelList.isPaginable = modelList.isPaginable
            }
        }
    }
    
}

final class CommitCellViewModel: TableCellViewModel {
   
    // MARK: - Properties
    
    typealias ModelType = CommitModel
    typealias CollectionCellViewModelType = UserCollectionCellViewModel
    
    var model: ModelType
    var author: OwnerModel?
    var htmlURL: URL
    var message: String
    
    // MARK: - Initialization
    
    init(from model: ModelType) {
        self.model = model
        author = model.author
        htmlURL = model.htmlURL
        message = model.message
    }
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        model = ModelType()
        author = OwnerModel()
        htmlURL = URL(string: "www.github.com")!
        message = ""
    }
    
    // MARK: - View Model Adapter Methods
    
    func collectionCellViewModel() -> CollectionCellViewModelType {
        return CollectionCellViewModelType()
    }
    
}
