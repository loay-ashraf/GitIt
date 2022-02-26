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
    var model = Observable<String>()
    var parameter = String()
    var defaultBranch = String()

    // MARK: - Initialization

    init(parameter: String, defaultBranch: String) {
        self.parameter = parameter
        self.defaultBranch = defaultBranch
    }
    
    // MARK: - Load Method
    
    func load() async -> NetworkError? {
        if !parameter.isEmpty {
            return processFetchResult(result: await fetchData())
        }
        return nil
    }
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<String, NetworkError> {
        await webServiceClient.downloadRepositoryLicense(fullName: parameter, branch: defaultBranch).flatMap { data -> Result<String, NetworkError> in
            return .success(String(data: data, encoding: .utf8) ?? "Error loading license")
        }
    }
    
    // MARK: - Check For Status Method
    
    func checkForStatus() async -> Array<Bool> {
        return []
    }
    
}
