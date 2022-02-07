//
//  CommitDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

class CommitDetailViewModel {
    
    // MARK: - Properties
    
    var logicController: CommitDetailLogicController
    
    var message: String = ""
    var htmlURL: URL = URL(string: "www.github.com")!
    var author: OwnerModel?
    
    // MARK: - Initialization
    
    init(tableCellViewModel: CommitCellViewModel) {
        let commitModel = CommitModel(message: tableCellViewModel.message, htmlURL: tableCellViewModel.htmlURL, author: tableCellViewModel.author)
        logicController = CommitDetailLogicController(model: commitModel)
    }
    
    init(model: CommitModel) {
        logicController = CommitDetailLogicController(model: model)
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.synchronizeModel()
                handler(nil)
            }
        }
    }
    
    // MARK: - Model Synchronization Methods
    
    private func synchronizeModel() {
        let model = logicController.model
        message = model.message
        htmlURL = model.htmlURL
        author = model.author
    }
    
}
