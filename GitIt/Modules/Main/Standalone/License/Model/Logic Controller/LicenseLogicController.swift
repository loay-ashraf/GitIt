//
//  LicenseLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import Foundation

class LicenseLogicController: WebServiceDetailLogicController {

    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = String
    
    var webServiceClient = GitHubClient()
    var model = String()
    var parameter = String()
    var defaultBranch = String()
    var handler: NetworkLoadingHandler?

    // MARK: - Initialization

    init(parameter: String, defaultBranch: String) {
        self.parameter = parameter
        self.defaultBranch = defaultBranch
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<String, NetworkError> {
        return await webServiceClient.downloadRepositoryLicense(fullName: parameter, branch: defaultBranch).flatMap { data -> Result<String, NetworkError> in
            return .success(String(data: data, encoding: .utf8) ?? "Error loading license")
        }
    }
    
    // MARK: - Check For Status Method
    
    func checkForStatus() async -> Array<Bool> {
        return []
    }
    
}
