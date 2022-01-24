//
//  GitHubRouter.swift
//  GitIt
//
//  Created by Loay Ashraf on 23/01/2022.
//

import Foundation
import Alamofire

enum GitHubRouter {
    
    // MARK: - GitHub API Route cases
    
    case fetchAuthenticatedUser
    case checkIfFollowingUser(login: String)
    case checkIfStarredRepository(fullName: String)
    case followUser(login: String)
    case unFollowUser(login: String)
    case starRepository(fullName: String)
    case unStarRepository(fullName: String)
    
    case fetchUsers(page: Int)
    case searchUsers(query: String, page: Int)
    case fetchUser(login: String)
    case fetchUserFolllowers(login: String, page: Int)
    case fetchUserFollowing(login: String, page: Int)
    case fetchUserRepositories(login: String, page: Int)
    case fetchUserOrganizations(login: String, page: Int)
    case fetchUserStarred(login: String, page: Int)
    
    case fetchRepositories(page: Int)
    case searchRepositories(query: String, page: Int)
    case fetchRepository(fullName: String)
    case fetchRepositoryStars(fullName: String, page: Int)
    case fetchRepositoryForks(fullName: String, page: Int)
    case fetchRepositoryContributors(fullName: String, page: Int)
    case fetchRepositoryCommits(fullName: String, page: Int)
    case downloadRepositoryREADME(fullName: String, branch: String)
    case downloadRepositoryLicense(fullName: String, branch: String)
    
    case fetchOrganizations(page: Int)
    case searchOrganizations(query: String, page: Int)
    case fetchOrganization(login: String)
    case fetchOrganizationMembers(login: String, page: Int)
    case fetchOrganizationRepositories(login: String, page: Int)
    
}

extension GitHubRouter {
    
    // MARK: - Base URL Property
    
    var baseURL: String {
        
        switch self {
        case .downloadRepositoryREADME,
            .downloadRepositoryLicense: return NetworkingConstants.rawContentBaseURL
        default: return NetworkingConstants.apiBaseUrl
        }
        
    }
    
    // MARK: - Path Property
    
    var path: String {
        
        switch self {
        case .fetchAuthenticatedUser: return NetworkingConstants.authenticatedUser
        case .followUser(let login),
            .unFollowUser(let login),
            .checkIfFollowingUser(let login): return NetworkingConstants.authenticatedUserFollowing.appendPathComponent(login)
        case .starRepository(let fullName),
            .unStarRepository(let fullName),
            .checkIfStarredRepository(let fullName): return NetworkingConstants.authenticatedUserStarred.appendPathComponent(fullName)
            
        case .fetchUser(let login): return NetworkingConstants.users.appendPathComponent(login)
        case .fetchUserFolllowers(let login, _): return NetworkingConstants.users.appendPathComponent(login).appendPathComponent(NetworkingConstants.followers)
        case .fetchUserFollowing(let login, _): return NetworkingConstants.users.appendPathComponent(login).appendPathComponent(NetworkingConstants.following)
        case .fetchUserRepositories(let login, _): return NetworkingConstants.users.appendPathComponent(login).appendPathComponent(NetworkingConstants.repositories)
        case .fetchUserOrganizations(let login, _): return NetworkingConstants.users.appendPathComponent(login).appendPathComponent(NetworkingConstants.organizations)
        case .fetchUserStarred(let login, _): return NetworkingConstants.users.appendPathComponent(login).appendPathComponent(NetworkingConstants.starred)
            
        case .fetchRepository(let fullName): return NetworkingConstants.repositories.appendPathComponent(fullName)
        case .fetchRepositoryStars(let fullName, _): return NetworkingConstants.repositories.appendPathComponent(fullName).appendPathComponent(NetworkingConstants.stargazers)
        case .fetchRepositoryForks(let fullName, _): return NetworkingConstants.repositories.appendPathComponent(fullName).appendPathComponent(NetworkingConstants.forks)
        case .fetchRepositoryContributors(let fullName, _): return NetworkingConstants.repositories.appendPathComponent(fullName).appendPathComponent(NetworkingConstants.contributors)
        case .fetchRepositoryCommits(let fullName, _): return NetworkingConstants.repositories.appendPathComponent(fullName).appendPathComponent(NetworkingConstants.commits)
            
        case .downloadRepositoryLicense(let fullName, let branch): return fullName.appendPathComponent(branch).appendPathComponent(NetworkingConstants.license)
        case .downloadRepositoryREADME(let fullName, let branch): return fullName.appendPathComponent(branch).appendPathComponent(NetworkingConstants.readme)

        case .fetchOrganization(let login): return NetworkingConstants.organizations.appendPathComponent(login)
        case .fetchOrganizationMembers(let login, _): return NetworkingConstants.organizations.appendPathComponent(login).appendPathComponent(NetworkingConstants.members)
        case .fetchOrganizationRepositories(let login, _): return NetworkingConstants.organizations.appendPathComponent(login).appendPathComponent(NetworkingConstants.repositories)
            
        case .fetchUsers,.searchUsers: return NetworkingConstants.searchUsers
        case .fetchRepositories,.searchRepositories: return NetworkingConstants.searchRepositories
        case .fetchOrganizations,.searchOrganizations: return NetworkingConstants.searchOrganizations
        }
        
    }
    
    // MARK: - Method Property
    
    var method: Alamofire.HTTPMethod {
        
        switch self {
        case .followUser,
            .starRepository: return .put
            
        case .unFollowUser,
            .unStarRepository: return .delete
            
        case .fetchAuthenticatedUser,
            .checkIfFollowingUser,
            .checkIfStarredRepository,
            .fetchUser,
            .fetchUsers,
            .searchUsers,
            .fetchUserFolllowers,
            .fetchUserFollowing,
            .fetchUserRepositories,
            .fetchUserOrganizations,
            .fetchUserStarred,
            .fetchRepository,
            .fetchRepositories,
            .searchRepositories,
            .fetchRepositoryStars,
            .fetchRepositoryForks,
            .fetchRepositoryContributors,
            .fetchRepositoryCommits,
            .downloadRepositoryREADME,
            .downloadRepositoryLicense,
            .fetchOrganization,
            .fetchOrganizations,
            .searchOrganizations,
            .fetchOrganizationMembers,
            .fetchOrganizationRepositories: return .get
        }
        
    }
    
    // MARK: - Headers Property
    
    var headers: HTTPHeaders {
            
        var headersDict : [String:String] = [:]
            
        switch self {
        case .followUser,
             .starRepository: headersDict[NetworkingConstants.contentType] = "application/json"
                              headersDict[NetworkingConstants.contentLength] = "zero"
        default: headersDict[NetworkingConstants.contentType] = "application/json"
        }
            
        return HTTPHeaders(headersDict)
            
    }
    
    // MARK: - Parameters Property
    
    var parameters: Parameters? {
            
        var parametersDict : [String: Any] = [:]
            
        switch self {
        case .searchUsers(let query, let page),
            .searchRepositories(let query, let page): parametersDict[NetworkingConstants.query] = query
                                                      parametersDict[NetworkingConstants.page] = page
                                                      parametersDict[NetworkingConstants.perPage] = NetworkingConstants.maxPageCapacity
        case .searchOrganizations(let query, let page): parametersDict[NetworkingConstants.query] = query.appendQueryComponent([NetworkingConstants.type:NetworkingConstants.organization].queryString)
                                                        parametersDict[NetworkingConstants.page] = page
                                                        parametersDict[NetworkingConstants.perPage] = NetworkingConstants.maxPageCapacity

        case .fetchUsers(let page): parametersDict[NetworkingConstants.query] = [NetworkingConstants.followers:">10"].queryString
                                    parametersDict[NetworkingConstants.page] = page
                                    parametersDict[NetworkingConstants.perPage] = NetworkingConstants.maxPageCapacity
            
        case .fetchUserFolllowers(_, let page),
            .fetchUserFollowing(_, let page),
            .fetchUserRepositories(_, let page),
            .fetchUserOrganizations(_, let page),
            .fetchUserStarred(_, let page): parametersDict[NetworkingConstants.page] = page
                                            parametersDict[NetworkingConstants.perPage] = NetworkingConstants.maxPageCapacity
            
            
        case .fetchRepositories(let page): parametersDict[NetworkingConstants.query] = [NetworkingConstants.stars:">10"].queryString
                                            parametersDict[NetworkingConstants.page] = page
                                            parametersDict[NetworkingConstants.perPage] = NetworkingConstants.maxPageCapacity
        
        case .fetchRepositoryStars(_, let page),
             .fetchRepositoryForks(_, let page),
             .fetchRepositoryContributors(_, let page),
             .fetchRepositoryCommits(_, let page): parametersDict[NetworkingConstants.page] = page
                                                   parametersDict[NetworkingConstants.perPage] = NetworkingConstants.maxPageCapacity
            
        case .fetchOrganizations(let page): parametersDict[NetworkingConstants.query] = [NetworkingConstants.type:NetworkingConstants.organization,NetworkingConstants.repositories:">10"].queryString
                                            parametersDict[NetworkingConstants.page] = page
                                            parametersDict[NetworkingConstants.perPage] = NetworkingConstants.maxPageCapacity
            
        case .fetchOrganizationMembers(_, let page),
            .fetchOrganizationRepositories(_, let page): parametersDict[NetworkingConstants.page] = page
                                                         parametersDict[NetworkingConstants.perPage] = NetworkingConstants.maxPageCapacity
            
        default: break
        }
            
        return parametersDict
    }
        
    // MARK: - Body Property
    
    var body : [String: Any]{
        
        var bodyDict: [String: Any] = [:]
            
        switch self {
        default: break
        }
            
        return bodyDict
    }
        
}

// MARK: - URL Request Convertible Protocol

extension GitHubRouter: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            
        urlRequest.method = method
        urlRequest.headers = headers
        
        if method == .get {
            urlRequest = try GitHubURLEncoding().encode(urlRequest, with: parameters)
        } else if method == .post {
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }

        switch self {
        case .checkIfFollowingUser,
            .checkIfStarredRepository,
            .followUser,
            .unFollowUser,
            .starRepository,
            .unStarRepository: urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        default: break
        }
        
        return urlRequest
    }
    
}
