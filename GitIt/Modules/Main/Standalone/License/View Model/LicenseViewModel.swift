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
    }
    
    init(withParameter parameter: String) {
        logicController = LicenseLogicController(withParameter: parameter)
    }
    
    // MARK: - Status Checking Method
    
    func checkForStatus() async -> Array<Bool> {
        return await logicController.checkForStatus()
    }
    
    // MARK: - Synchronize Method
    
    func synchronize() {
        licenseText = logicController.model
    }
    
}
