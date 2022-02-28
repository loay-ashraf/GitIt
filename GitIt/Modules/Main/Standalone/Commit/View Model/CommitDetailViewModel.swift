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
    
    var message: String = ""
    var htmlURL: URL = URL(string: "www.github.com")!
    var author: OwnerModel?
    
    // MARK: - Initialization
    
    init(tableCellViewModel: CommitCellViewModel) {
        let commitModel = CommitModel(message: tableCellViewModel.message, htmlURL: tableCellViewModel.htmlURL, author: tableCellViewModel.author)
        logicController = CommitDetailLogicController(model: commitModel)
        bindToModel()
    }
    
    init(model: CommitModel) {
        logicController = CommitDetailLogicController(model: model)
        bindToModel()
    }
    
    init(withParameter parameter: String) {
        logicController = CommitDetailLogicController(withParameter: parameter)
        bindToModel()
    }
    
    // MARK: - Status Checking Method
    
    func checkForStatus() async -> Array<Bool> {
        return await logicController.checkForStatus()
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] modelObject in
            if let modelObject = modelObject {
                self?.message = modelObject.message
                self?.htmlURL = modelObject.htmlURL
                self?.author = modelObject.author
            }
        }
    }
    
}
