//
//  LicenseViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/02/2022.
//

import Foundation

final class LicenseViewModel: WebServiceDetailViewModel {
   
    // MARK: - Properties
    
    typealias WebServiceLogicControllerType = LicenseLogicController
    
    var logicController: LicenseLogicController
    var handler: NetworkLoadingHandler?
    
    var licenseText = String()
    
    // MARK: - Initialization
    
    init(parameter: String, defaultBranch: String) {
        logicController = LicenseLogicController(parameter: parameter, defaultBranch: defaultBranch)
        bindToModel()
    }
    
    init(withParameter parameter: String) {
        logicController = LicenseLogicController(withParameter: parameter)
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
                self?.licenseText = modelObject
            }
        }
    }
    
}
