//
//  OrganizationTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

enum OrganizationContext {
    
    case main
    case user(userLogin: String)
    
    var logicController: OrganizationLogicController {
        switch self {
        case .main: return OrganizationLogicController()
        case .user(let userLogin): return UserEnrolledLogicController(userLogin: userLogin)
        }
    }
    
    var title: String {
       return Constants.View.Title.organizations.main
    }
    
}
