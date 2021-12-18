//
//  LicenseLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import Foundation

class LicenseLogicController {

    var model = String()
    var parameters: (String,String)
    
    typealias ViewStateHandler = (LicenseViewState) -> Void

    // MARK: - Initialisation

    init(parameters: (String,String)) {
        self.parameters = parameters
    }

    // MARK: - Business Logic Methods

    func load(then handler: @escaping ViewStateHandler) {
        GithubClient.standard.getRepositoryLicense(fullName: parameters.0, branch: parameters.1) { result in
            switch result {
            case .success(let response): self.model = String(data: response, encoding: .utf8) ?? "Error loading license"
                                         handler(.presenting)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }
    
}
