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
    
    func fetchData() {
        webServiceClient.downloadRepositoryLicense(fullName: parameter, branch: defaultBranch, completionHandler: processFetchResult(result:))
    }
    
    // MARK: - Fetch Result Processing Method
    
    func processFetchResult(result: Result<Data, NetworkError>) {
        switch result {
        case .success(let response): self.model = String(data: response, encoding: .utf8) ?? "Error loading license"
                                     self.handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
    // MARK: - Check For Status Method
    
    func checkForStatus(then handler: @escaping ([Bool]) -> Void) {
        return
    }
    
}
