//
//  LicenseLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import Foundation

class LicenseLogicController {

    var model = String()
    var repositoryFullName: String
    var defaultBranch: String

    // MARK: - Initialization

    init(repositoryFullName: String, defaultBranch: String) {
        self.repositoryFullName = repositoryFullName
        self.defaultBranch = defaultBranch
    }

    // MARK: - Business Logic Methods

    func load(then handler: @escaping LoadingHandler) {
        GitHubClient.downloadRepositoryLicense(fullName: repositoryFullName, branch: defaultBranch) { result in
            switch result {
            case .success(let response): self.model = String(data: response, encoding: .utf8) ?? "Error loading license"
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
}
