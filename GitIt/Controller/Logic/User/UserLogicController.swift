//
//  UserLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/11/2021.
//

import Foundation

class UserLogicController {
    
    var model = List<UserModel>()
    var context: UserContext
    private var contextParameters: Any?
    
    init(context: UserContext, contextParameters: Any? = nil) {
        self.context = context
        self.contextParameters = contextParameters
        switch context {
        case .main: model.isPaginable = true
        case .followers: model.isPaginable = (contextParameters as! UserContext.FollowersParameters).1 > 10 ? true : false
        case .following: model.isPaginable = (contextParameters as! UserContext.FollowingParameters).1 > 10 ? true : false
        case .stars: model.isPaginable = (contextParameters as! UserContext.StarsParameters).1 > 10 ? true : false
        case .contributors: model.isPaginable = true
        case .members: model.isPaginable = true
        }
    }
    
    func load(then handler: @escaping ErrorHandler) {
        switch context {
        case .main: loadMain(then: handler)
        case .followers: loadFollowers(then: handler)
        case .following: loadFollowing(then: handler)
        case .stars: loadStars(then: handler)
        case .contributors: loadContributers(then: handler)
        case .members: loadMembers(then: handler)
        }
    }
    
    func refresh(then handler: @escaping ErrorHandler) {
        model.reset()
        load(then: handler)
    }
    
    private func loadMain(then handler: @escaping ErrorHandler) {
        NetworkClient.standard.getUserPage(page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    private func loadFollowers(then handler: @escaping ErrorHandler) {
        let parameters = contextParameters as! UserContext.FollowersParameters
        NetworkClient.standard.getUserFollowers(userLogin: parameters.0, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    private func loadFollowing(then handler: @escaping ErrorHandler) {
        let parameters = contextParameters as! UserContext.FollowingParameters
        NetworkClient.standard.getUserFollowing(userLogin: parameters.0, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    private func loadStars(then handler: @escaping ErrorHandler) {
        let parameters = contextParameters as! UserContext.StarsParameters
        NetworkClient.standard.getRepositoryStars(fullName: parameters.0, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters()
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    private func loadContributers(then handler: @escaping ErrorHandler) {
        let parameters = contextParameters as! UserContext.ContributorsParameters
        NetworkClient.standard.getRepositoryContributors(fullName: parameters, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters(newItemsCount: response.count)
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    private func loadMembers(then handler: @escaping ErrorHandler) {
        let parameters = contextParameters as! UserContext.MembersParameters
        NetworkClient.standard.getOrganizationMemebers(organizationLogin: parameters, page: model.currentPage, perPage: 10) { result in
            switch result {
            case .success(let response): self.model.append(contentsOf: response)
                                         self.updateModelParameters(newItemsCount: response.count)
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    private func updateModelParameters(newItemsCount: Int = 0) {
        model.currentPage += 1
        switch context {
        case .main: model.isPaginable = true
        case .followers: model.isPaginable = model.items.count == (contextParameters as! UserContext.FollowersParameters).1 ? false : true
        case .following: model.isPaginable = model.items.count == (contextParameters as! UserContext.FollowingParameters).1 ? false : true
        case .stars: model.isPaginable = model.items.count == (contextParameters as! UserContext.StarsParameters).1 ? false : true
        case .contributors: model.isPaginable = newItemsCount == 0 ? false : true
        case .members: model.isPaginable = newItemsCount == 0 ? false : true
        }
    }
    
}
