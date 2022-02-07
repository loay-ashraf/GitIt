//
//  UserTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

enum UserContext: ViewControllerContext {
    
    case main
    case followers(userLogin: String,numberOfFollowers: Int)
    case following(userLogin: String,numberOfFollowing: Int)
    case stargazers(repositoryFullName: String,numberOfStargazers: Int)
    case contributors(repositoryFullName: String)
    case members(organizationLogin: String)
    
    var logicController: UserLogicController {
        switch self {
        case .main: return UserLogicController()
        case .followers(let userLogin, let numberOfFollowers): return FollowersLogicController(userLogin: userLogin, numberofFollowers: numberOfFollowers)
        case .following(let userLogin, let numberOfFollowing): return FollowingLogicController(userLogin: userLogin, numberofFollowing: numberOfFollowing)
        case .stargazers(let repositoryFullName, let numberOfStargazers): return StargazersLogicController(repositoryFullName: repositoryFullName, numberofStargazers: numberOfStargazers)
        case .contributors(let repositoryFullName): return ContributorsLogicController(repositoryFullName: repositoryFullName)
        case .members(let organizationLogin): return MembersLogicController(organizationLogin: organizationLogin)
        }
    }
    
    var title: String {
        switch self {
        case .main: return TitleConstants.users.main
        case .followers: return TitleConstants.users.followers
        case .following: return TitleConstants.users.following
        case .stargazers: return TitleConstants.users.stargazers
        case .contributors: return TitleConstants.users.contributors
        case .members: return TitleConstants.users.members
        }
    }

}

protocol ViewControllerContext {
    
}
