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
    private var handler: LoadingHandler?
    
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
    
    func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        switch context {
        case .main: loadMain()
        case .followers: loadFollowers()
        case .following: loadFollowing()
        case .stars: loadStars()
        case .contributors: loadContributers()
        case .members: loadMembers()
        }
    }
    
    func refresh(then handler: @escaping LoadingHandler) {
        model.reset()
        load(then: handler)
    }
    
    private func loadMain() {
        GitHubClient.fetchUsers(page: model.currentPage, completionHandler: processResult(result:))
    }
    
    private func loadFollowers() {
        let parameters = contextParameters as! UserContext.FollowersParameters
        GitHubClient.fetchUserFollowers(userLogin: parameters.0, page: model.currentPage, completion: processResult(result:))
    }
    
    private func loadFollowing() {
        let parameters = contextParameters as! UserContext.FollowingParameters
        GitHubClient.fetchUserFollowing(userLogin: parameters.0, page: model.currentPage, completion: processResult(result:))
    }
    
    private func loadStars() {
        let parameters = contextParameters as! UserContext.StarsParameters
        GitHubClient.fetchRepositoryStars(fullName: parameters.0, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    private func loadContributers() {
        let parameters = contextParameters as! UserContext.ContributorsParameters
        GitHubClient.fetchRepositoryContributors(fullName: parameters, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    private func loadMembers() {
        let parameters = contextParameters as! UserContext.MembersParameters
        GitHubClient.fetchOrganizationMemebers(organizationLogin: parameters, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    private func processResult(result: Result<[UserModel],NetworkError>) {
        switch result {
        case .success(let response): model.append(contentsOf: response)
                                     updateModelParameters(newItemsCount: response.count)
                                     handler?(nil)
        case .failure(let networkError): handler?(networkError)
        }
    }
    
    private func updateModelParameters(newItemsCount: Int = 0) {
        switch context {
        case .main: model.isPaginable = true
        case .followers: model.isPaginable = model.items.count == (contextParameters as! UserContext.FollowersParameters).1 ? false : true
        case .following: model.isPaginable = model.items.count == (contextParameters as! UserContext.FollowingParameters).1 ? false : true
        case .stars: model.isPaginable = model.items.count == (contextParameters as! UserContext.StarsParameters).1 ? false : true
        case .contributors: model.isPaginable = newItemsCount == 0 ? false : true
        case .members: model.isPaginable = newItemsCount == 0 ? false : true
        }
        if model.currentPage == 100 {
            model.isPaginable = false
        } else {
            model.currentPage += 1
        }
    }
    
}
