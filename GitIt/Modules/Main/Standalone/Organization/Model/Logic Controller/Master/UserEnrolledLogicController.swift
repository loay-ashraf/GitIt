//
//  UserEnrolledLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

final class UserEnrolledLogicController: OrganizationLogicController {
    
    // MARK: - Properties
    
    var userLogin = String()
    
    // MARK: - Initialization
    
    init(userLogin: String) {
        self.userLogin = userLogin
        super.init(maxItemCount: nil)
    }
    
    required init(maxItemCount: Int?, maxPageCount: Int = NetworkingConstants.maxPageCount) {
        super.init(maxItemCount: maxItemCount, maxPageCount: maxPageCount)
    }
    
    // MARK: - Fetch Data Method
    
    override func fetchData() {
        webServiceClient.fetchUserOrganizations(userLogin: userLogin, page: model.currentPage, completion: processFetchResult(result:))
    }
    
}
