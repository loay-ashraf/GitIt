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
    var model = Observable<CommitModel>()
    var parameter = String()
    
    // MARK: - Initialization

    init(model: CommitModel) {
        self.modelObject = model
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<CommitModel,NetworkError> {
        return .success(modelObject)
    }
    
    // MARK: - Check For Status Method
    
    func checkForStatus() async -> Array<Bool> {
        return []
    }
    
}
