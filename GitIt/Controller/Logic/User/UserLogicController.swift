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
    
    typealias ViewStateHandler = (ViewState) -> Void
    
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
    
    func refresh(then handler: @escaping ViewStateHandler) {
        model.reset()
        load(then: handler)
    }
    
    func load(then handler: @escaping ViewStateHandler) {
        switch context {
        case .main: loadMain(then: handler)
        case .followers: loadFollowers(then: handler)
        case .following: loadFollowing(then: handler)
        case .stars: loadStars(then: handler)
        case .contributors: loadContributers(then: handler)
        case .members: loadMembers(then: handler)
        }
    }
    
    private func loadMain(then handler: @escaping ViewStateHandler) {
        GithubClient.standard.getUserPage(page: model.currentPage, perPage: 10) { response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters()
                handler(.presenting)
            }
        }
    }
    
    private func loadFollowers(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! UserContext.FollowersParameters
        GithubClient.standard.getUserFollowers(userLogin: parameters.0, page: model.currentPage, perPage: 10) { response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters()
                handler(.presenting)
            }
        }
    }
    
    private func loadFollowing(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! UserContext.FollowingParameters
        GithubClient.standard.getUserFollowing(userLogin: parameters.0, page: model.currentPage, perPage: 10) { response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters(newItemsCount: response.count)
                handler(.presenting)
            }
        }
    }
    
    private func loadStars(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! UserContext.StarsParameters
        GithubClient.standard.getRepositoryStars(fullName: parameters.0, page: model.currentPage, perPage: 10) { response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters()
                handler(.presenting)
            }
        }
    }
    
    private func loadContributers(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! UserContext.ContributorsParameters
        GithubClient.standard.getRepositoryContributors(fullName: parameters, page: model.currentPage, perPage: 10) { response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters(newItemsCount: response.count)
                handler(.presenting)
            }
        }
    }
    
    private func loadMembers(then handler: @escaping ViewStateHandler) {
        let parameters = contextParameters as! UserContext.MembersParameters
        GithubClient.standard.getOrganizationMemebers(organizationLogin: parameters, page: model.currentPage, perPage: 10) { response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.model.append(contentsOf: response)
                self.updateModelParameters(newItemsCount: response.count)
                handler(.presenting)
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
