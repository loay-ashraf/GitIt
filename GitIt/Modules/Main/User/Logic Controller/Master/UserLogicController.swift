//
//  UserLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/11/2021.
//

import Foundation

class UserLogicController {
    
    var model = List<UserModel>()
    var handler: LoadingHandler?
    
    init() {
        model.isPaginable = true
    }
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchUsers(page: model.currentPage, completionHandler: processResult(result:))
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    func processResult(result: Result<[UserModel],NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response)
                                     updateModelParameters(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
    func updateModelParameters(newItemsCount: Int = 0) {
        if model.currentPage == NetworkingConstants.maxPageCount {
            model.isPaginable = false
            return
        } else {
            model.currentPage += 1
        }
    }
    
}