//
//  GitHubClient.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import Foundation

class GitHubClient {
    
    static let networkManager = NetworkManager.standard
    
    // MARK: - User Search Methods
    
    class func fetchUsers(page: Int, completionHandler: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        func handler(result: Result<BatchResponse<UserModel>,NetworkError>) {
            switch result {
            case .success(let response): completionHandler(.success(response.items))
            case .failure(let networkError): completionHandler(.failure(networkError))
            }
        }
        _ = networkManager.dataRequest(request: GitHubRouter.fetchUsers(page: page), completionHandler: handler(result:))
    }
    
    class func searchUsers(keyword: String, page: Int, completionHandler: @escaping (Result<BatchResponse<UserModel>,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.searchUsers(query: keyword, page: page), completionHandler: completionHandler)
    }
    
    // MARK: - Authenticated User Methods
    
    class func fetchAuthenticatedUser(completionHandler: @escaping (Result<UserModel,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchAuthenticatedUser, completionHandler: completionHandler)
    }
    
    class func checkIfFollowingUser(userLogin: String, completionHandler: @escaping (NetworkError?) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.checkIfFollowingUser(login: userLogin), completionHandler: completionHandler)
    }
    
    class func checkIfStarredRepository(fullName: String, completionHandler: @escaping (NetworkError?) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.checkIfStarredRepository(fullName: fullName), completionHandler: completionHandler)
    }
    
    class func followUser(userLogin: String, completionHandler: @escaping (NetworkError?) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.followUser(login: userLogin), completionHandler: completionHandler)
    }
    
    class func unFollowUser(userLogin: String, completionHandler: @escaping (NetworkError?) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.unFollowUser(login: userLogin), completionHandler: completionHandler)
    }
    
    class func starRepository(fullName: String, completionHandler: @escaping (NetworkError?) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.starRepository(fullName: fullName), completionHandler: completionHandler)
    }
    
    class func unStarRepository(fullName: String, completionHandler: @escaping (NetworkError?) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.unStarRepository(fullName: fullName), completionHandler: completionHandler)
    }
    
    // MARK: - Regular User Methods
    
    class func fetchUser(userLogin: String, completion: @escaping (Result<UserModel,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchUser(login: userLogin), completionHandler: completion)
    }
    
    class func fetchUserFollowers(userLogin: String, page: Int, completion: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchUserFolllowers(login: userLogin, page: page), completionHandler: completion)
    }
    
    class func fetchUserFollowing(userLogin: String, page: Int, completion: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchUserFollowing(login: userLogin, page: page), completionHandler: completion)
    }
    
    class func fetchUserRepositories(userLogin: String, page: Int, completion: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchUserRepositories(login: userLogin, page: page), completionHandler: completion)
    }
    
    class func fetchUserOrganizations(userLogin: String, page: Int, completion: @escaping (Result<[OrganizationModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchUserOrganizations(login: userLogin, page: page), completionHandler: completion)
    }
    
    class func fetchUserStarred(userLogin: String, page: Int, completion: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchUserStarred(login: userLogin, page: page), completionHandler: completion)
    }
    
    // MARK: - Repository Search Methods
    
    class func fetchRepositories(page: Int, completionHandler: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        func handler(result: Result<BatchResponse<RepositoryModel>,NetworkError>) {
            switch result {
            case .success(let response): completionHandler(.success(response.items))
            case .failure(let networkError): completionHandler(.failure(networkError))
            }
        }
        _ = networkManager.dataRequest(request: GitHubRouter.fetchRepositories(page: page), completionHandler: handler(result:))
    }
    
    class func fetchTrendingRepositories(page: Int, completionHandler: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        func handler(result: Result<BatchResponse<RepositoryModel>,NetworkError>) {
            switch result {
            case .success(let response): completionHandler(.success(response.items))
            case .failure(let networkError): completionHandler(.failure(networkError))
            }
        }
        _ = networkManager.dataRequest(request: GitHubRouter.fetchTrendingRepositories(page: page), completionHandler: handler(result:))
    }
    
    class func searchRepositories(keyword: String, page: Int, completionHandler: @escaping (Result<BatchResponse<RepositoryModel>,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.searchRepositories(query: keyword, page: page), completionHandler: completionHandler)
    }
    
    // MARK: - Repository Methods
    
    class func fetchRepository(fullName: String, completionHandler: @escaping (Result<RepositoryModel,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchRepository(fullName: fullName), completionHandler: completionHandler)
    }
    
    class func fetchRepositoryStars(fullName: String, page: Int, completionHandler: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchRepositoryStars(fullName: fullName, page: page), completionHandler: completionHandler)
    }
    
    class func fetchRepositoryForks(fullName: String, page: Int, completionHandler: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchRepositoryForks(fullName: fullName, page: page), completionHandler: completionHandler)
    }
    
    class func fetchRepositoryContributors(fullName: String, page: Int, completionHandler: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchRepositoryContributors(fullName: fullName, page: page), completionHandler: completionHandler)
    }
    
    class func fetchRepositoryCommits(fullName: String, page: Int, completionHandler: @escaping (Result<[CommitModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchRepositoryCommits(fullName: fullName, page: page), completionHandler: completionHandler)
    }
    
    class func downloadRepositoryLicense(fullName: String, branch: String, completionHandler: @escaping (Result<Data,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.downloadRepositoryLicense(fullName: fullName, branch: branch), completionHandler: completionHandler)
    }
    
    class func downloadRepositoryREADME(fullName: String, branch: String, completionHandler: @escaping (Result<Data,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.downloadRepositoryREADME(fullName: fullName, branch: branch), completionHandler: completionHandler)
    }
    
    // MARK: - Organization Search Methods
    
    class func fetchOrganizations(page: Int, completionHandler: @escaping (Result<[OrganizationModel],NetworkError>) -> Void) {
        func handler(result: Result<BatchResponse<OrganizationModel>,NetworkError>) {
            switch result {
            case .success(let response): completionHandler(.success(response.items))
            case .failure(let networkError): completionHandler(.failure(networkError))
            }
        }
        _ = networkManager.dataRequest(request: GitHubRouter.fetchOrganizations(page: page), completionHandler: handler(result:))
    }
    
    class func searchOrganizations(keyword: String, page: Int, completionHandler: @escaping (Result<BatchResponse<OrganizationModel>,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.searchOrganizations(query: keyword, page: page), completionHandler: completionHandler)
    }
    
    // MARK: - Organization Methods
    
    class func fetchOrganization(organizationLogin: String, completionHandler: @escaping (Result<OrganizationModel,NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchOrganization(login: organizationLogin), completionHandler: completionHandler)
    }
    
    class func fetchOrganizationMemebers(organizationLogin: String, page: Int, completionHandler: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchOrganizationMembers(login: organizationLogin, page: page), completionHandler: completionHandler)
    }
    
    class func fetchOrganizationRepositories(organizationLogin: String, page: Int, completionHandler: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        _ = networkManager.dataRequest(request: GitHubRouter.fetchOrganizationRepositories(login: organizationLogin, page: page), completionHandler: completionHandler)
    }

}
