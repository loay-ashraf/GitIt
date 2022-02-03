//
//  LicenseViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

class LicenseViewModel {
    
    var logicController: LicenseLogicController
    var licenseText: String
    
    init(repositoryFullName: String, defaultBranch: String) {
        logicController = LicenseLogicController(repositoryFullName: repositoryFullName, defaultBranch: defaultBranch)
        licenseText = String()
    }
    
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
    
    private func synchronizeModel() {
        licenseText = logicController.model
    }
    
}
