//
//  UserTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

enum UserContext {
    
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
        case .main: return Constants.View.Title.users.main
        case .followers: return Constants.View.Title.users.followers
        case .following: return Constants.View.Title.users.following
        case .stargazers: return Constants.View.Title.users.stargazers
        case .contributors: return Constants.View.Title.users.contributors
        case .members: return Constants.View.Title.users.members
        }
    }

}
