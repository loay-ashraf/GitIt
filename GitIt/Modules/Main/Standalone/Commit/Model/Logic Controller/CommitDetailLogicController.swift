//
//  CommitDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import Foundation

class CommitDetailLogicController: WebServiceDetailLogicController {
    
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = CommitModel
    
    var webServiceClient = GitHubClient()
    var model = CommitModel()
    var parameter = String()
    var handler: NetworkLoadingHandler?
    
    // MARK: - Initialization

    init(model: CommitModel) {
        self.model = model
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() {
        handler?(nil)
    }
    
    // MARK: - Check For Status Method
    
    func checkForStatus(then handler: @escaping ([Bool]) -> Void) {
        handler([])
    }
    
}
