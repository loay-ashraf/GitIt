//
//  CommitDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

final class CommitDetailViewModel: WebServiceDetailViewModel {
    
    // MARK: - Properties
    
    typealias WebServiceLogicControllerType = CommitDetailLogicController
    
    var logicController: CommitDetailLogicController
    var handler: NetworkLoadingHandler?
    
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
    
    init(withParameter parameter: String) {
        logicController = CommitDetailLogicController(withParameter: parameter)
    }
    
    // MARK: - Status Checking Method
    
    func checkForStatus() {
        handler?(nil)
    }
    
    // MARK: - Synchronize Method
    
    func synchronize() {
        let model = logicController.model
        message = model.message
        htmlURL = model.htmlURL
        author = model.author
    }
    
}
