//
//  GitHubClient.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import Foundation

final class GitHubClient: WebServiceClient {
    
    // MARK: - User Search Methods
    
    func fetchUsers(page: Int) async -> Result<[UserModel],NetworkError> {
        let result: Result<BatchResponse<UserModel>,NetworkError> = await networkManager.dataRequest(request: GitHubRouter.fetchUsers(page: page))
        return result.flatMap { batchResponse -> Result<[UserModel],NetworkError> in return .success(batchResponse.items) }
    }
    
    func searchUsers(query: String, page: Int) async -> Result<BatchResponse<UserModel>,NetworkError> {
         await networkManager.dataRequest(request: GitHubRouter.searchUsers(query: query, page: page))
    }
    
    // MARK: - Authenticated User Methods
    
    func fetchAuthenticatedUser() async -> Result<UserModel,NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchAuthenticatedUser)
    }
    
    func checkIfFollowingUser(userLogin: String) async -> NetworkError? {
        await networkManager.dataRequest(request: GitHubRouter.checkIfFollowingUser(login: userLogin))
    }
    
    func checkIfStarredRepository(fullName: String) async -> NetworkError? {
        await networkManager.dataRequest(request: GitHubRouter.checkIfStarredRepository(fullName: fullName))
    }
    
    func followUser(userLogin: String) async -> NetworkError? {
        await networkManager.dataRequest(request: GitHubRouter.followUser(login: userLogin))
    }
    
    func unFollowUser(userLogin: String) async -> NetworkError? {
        await networkManager.dataRequest(request: GitHubRouter.unFollowUser(login: userLogin))
    }
    
    func starRepository(fullName: String) async -> NetworkError? {
        await networkManager.dataRequest(request: GitHubRouter.starRepository(fullName: fullName))
    }
    
    func unStarRepository(fullName: String) async -> NetworkError? {
        await networkManager.dataRequest(request: GitHubRouter.unStarRepository(fullName: fullName))
    }
    
    // MARK: - Regular User Methods
    
    func fetchUser(userLogin: String) async -> Result<UserModel,NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchUser(login: userLogin))
    }
    
    func fetchUserFollowers(userLogin: String, page: Int) async -> Result<[UserModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchUserFolllowers(login: userLogin, page: page))
    }
    
    func fetchUserFollowing(userLogin: String, page: Int) async -> Result<[UserModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchUserFollowing(login: userLogin, page: page))
    }
    
    func fetchUserRepositories(userLogin: String, page: Int) async -> Result<[RepositoryModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchUserRepositories(login: userLogin, page: page))
    }
    
    func fetchUserOrganizations(userLogin: String, page: Int) async -> Result<[OrganizationModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchUserOrganizations(login: userLogin, page: page))
    }
    
    func fetchUserStarred(userLogin: String, page: Int) async -> Result<[RepositoryModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchUserStarred(login: userLogin, page: page))
    }
    
    // MARK: - Repository Search Methods
    
    func fetchRepositories(page: Int) async -> Result<[RepositoryModel],NetworkError> {
        let result: Result<BatchResponse<RepositoryModel>,NetworkError> = await networkManager.dataRequest(request: GitHubRouter.fetchRepositories(page: page))
        return result.flatMap { batchResponse -> Result<[RepositoryModel],NetworkError> in return .success(batchResponse.items) }
    }
    
    func fetchTrendingRepositories(page: Int) async -> Result<[RepositoryModel],NetworkError>  {
        let result: Result<BatchResponse<RepositoryModel>,NetworkError> = await networkManager.dataRequest(request: GitHubRouter.fetchTrendingRepositories(page: page))
        return result.flatMap { batchResponse -> Result<[RepositoryModel],NetworkError> in return .success(batchResponse.items) }
    }
    
    func searchRepositories(query: String, page: Int) async -> Result<BatchResponse<RepositoryModel>,NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.searchRepositories(query: query, page: page))
    }
    
    // MARK: - Repository Methods
    
    func fetchRepository(fullName: String) async -> Result<RepositoryModel,NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchRepository(fullName: fullName))
    }
    
    func fetchRepositoryStars(fullName: String, page: Int) async -> Result<[UserModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchRepositoryStars(fullName: fullName, page: page))
    }
    
    func fetchRepositoryForks(fullName: String, page: Int) async -> Result<[RepositoryModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchRepositoryForks(fullName: fullName, page: page))
    }
    
    func fetchRepositoryContributors(fullName: String, page: Int) async -> Result<[UserModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchRepositoryContributors(fullName: fullName, page: page))
    }
    
    func fetchRepositoryCommits(fullName: String, page: Int) async -> Result<[CommitModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchRepositoryCommits(fullName: fullName, page: page))
    }
    
    func downloadRepositoryLicense(fullName: String, branch: String) async -> DataResult {
        await networkManager.dataRequest(request: GitHubRouter.downloadRepositoryLicense(fullName: fullName, branch: branch))
    }
    
    func downloadRepositoryREADME(fullName: String, branch: String) async -> DataResult {
        await networkManager.dataRequest(request: GitHubRouter.downloadRepositoryREADME(fullName: fullName, branch: branch))
    }
    
    // MARK: - Organization Search Methods
    
    func fetchOrganizations(page: Int) async -> Result<[OrganizationModel],NetworkError> {
        let result: Result<BatchResponse<OrganizationModel>,NetworkError> = await networkManager.dataRequest(request: GitHubRouter.fetchOrganizations(page: page))
        return result.flatMap { batchResponse -> Result<[OrganizationModel],NetworkError> in return .success(batchResponse.items) }
    }
    
    func searchOrganizations(query: String, page: Int) async -> Result<BatchResponse<OrganizationModel>,NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.searchOrganizations(query: query, page: page))
    }
    
    // MARK: - Organization Methods
    
    func fetchOrganization(organizationLogin: String) async -> Result<OrganizationModel,NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchOrganization(login: organizationLogin))
    }
    
    func fetchOrganizationMemebers(organizationLogin: String, page: Int) async -> Result<[UserModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchOrganizationMembers(login: organizationLogin, page: page))
    }
    
    func fetchOrganizationRepositories(organizationLogin: String, page: Int) async -> Result<[RepositoryModel],NetworkError> {
        await networkManager.dataRequest(request: GitHubRouter.fetchOrganizationRepositories(login: organizationLogin, page: page))
    }

}
