//
//  GithubClient.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import Foundation

class GithubClient {
    
    static let standard = GithubClient()
    
    private init() {
        
    }
    
    // MARK: - User Search Methods
    
    func getUserPage(page: Int, perPage: Int, completion: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.list(page, perPage).url, responseType: BatchResponse<UserModel>.self) { result in
            switch result {
            case .success(let response): completion(.success(response.items))
            case .failure(let networkError): completion(.failure(networkError))
            }
        }
    }
    
    func getUserSearchPage(keyword: String, page: Int, perPage: Int, completion: @escaping (Result<BatchResponse<UserModel>,NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.search(keyword, page, perPage).url, responseType: BatchResponse<UserModel>.self, completion: completion)
    }
    
    // MARK: - Authenticated User Methods
    
    func getAuthenticatedUser(completion: @escaping (Result<UserModel,NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.authenticatedUser.url, responseType: UserModel.self, completion: completion)
    }
    
    func checkAuthenticatedUserIsFollowing(userLogin: String, completion: @escaping (NetworkError?) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.authenticatedUserFollow(userLogin).url, completion: completion)
    }
    
    func checkAuthenticatedUserDidStar(fullName: String, completion: @escaping (NetworkError?) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.authenticatedUserStar(fullName).url, completion: completion)
    }
    
    func authenticatedUserFollow(userLogin: String, completion: @escaping (NetworkError?) -> Void) {
        NetworkManager.standard.PUTRequest(url: UserEndpoints.authenticatedUserFollow(userLogin).url, completion: completion)
    }
    
    func authenticatedUserStar(fullName: String, completion: @escaping (NetworkError?) -> Void) {
        NetworkManager.standard.PUTRequest(url: UserEndpoints.authenticatedUserStar(fullName).url, completion: completion)
    }
    
    func authenticatedUserUnfollow(userLogin: String, completion: @escaping (NetworkError?) -> Void) {
        NetworkManager.standard.DELETERequest(url: UserEndpoints.authenticatedUserFollow(userLogin).url, completion: completion)
    }
    
    func authenticatedUserUnstar(fullName: String, completion: @escaping (NetworkError?) -> Void) {
        NetworkManager.standard.DELETERequest(url: UserEndpoints.authenticatedUserStar(fullName).url, completion: completion)
    }
    
    // MARK: - Regular User Methods
    
    func getUser(userLogin: String, completion: @escaping (Result<UserModel,NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.user(userLogin).url, responseType: UserModel.self, completion: completion)
    }
    
    func getUserFollowers(userLogin: String, page: Int, perPage: Int, completion: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.followers(userLogin, page, perPage).url, responseType: [UserModel].self, completion: completion)
    }
    
    func getUserFollowing(userLogin: String, page: Int, perPage: Int, completion: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.following(userLogin, page, perPage).url, responseType: [UserModel].self, completion: completion)
    }
    
    func getUserRepositories(userLogin: String, page: Int, perPage: Int, completion: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.repositories(userLogin, page, perPage).url, responseType: [RepositoryModel].self, completion: completion)
    }
    
    func getUserOrganizations(userLogin: String, page: Int, perPage: Int, completion: @escaping (Result<[OrganizationModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.organizations(userLogin, page, perPage).url, responseType: [OrganizationModel].self, completion: completion)
    }
    
    func getUserStarred(userLogin: String, page: Int, perPage: Int, completion: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: UserEndpoints.starred(userLogin, page, perPage).url, responseType: [RepositoryModel].self, completion: completion)
    }
    
    // MARK: - Repository Search Methods
    
    func getRepositoryPage(page: Int, perPage: Int, completion: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: RepositoryEndpoints.list(page, perPage).url, responseType: BatchResponse<RepositoryModel>.self) { result in
            switch result {
            case .success(let response): completion(.success(response.items))
            case .failure(let networkError): completion(.failure(networkError))
            }
        }
    }
    
    func getRepositorySearchPage(keyword: String, page: Int, perPage: Int, completion: @escaping (Result<BatchResponse<RepositoryModel>,NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: RepositoryEndpoints.search(keyword, page, perPage).url, responseType: BatchResponse<RepositoryModel>.self, completion: completion)
    }
    
    // MARK: - Repository Methods
    
    func getRepository(fullName: String, completion: @escaping (Result<RepositoryModel,NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: RepositoryEndpoints.repository(fullName).url, responseType: RepositoryModel.self, completion: completion)
    }
    
    func getRepositoryStars(fullName: String, page: Int, perPage: Int, completion: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: RepositoryEndpoints.stars(fullName, page, perPage).url, responseType: [UserModel].self, completion: completion)
    }
    
    func getRepositoryForks(fullName: String, page: Int, perPage: Int, completion: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: RepositoryEndpoints.forks(fullName, page, perPage).url, responseType: [RepositoryModel].self, completion: completion)
    }
    
    func getRepositoryContributors(fullName: String, page: Int, perPage: Int, completion: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: RepositoryEndpoints.contributors(fullName, page, perPage).url, responseType: [UserModel].self, completion: completion)
    }
    
    func getRepositoryCommits(fullName: String, page: Int, perPage: Int, completion: @escaping (Result<[CommitModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: RepositoryEndpoints.commits(fullName, page, perPage).url, responseType: [CommitModel].self, completion: completion)
    }
    
    func getRepositoryLicense(fullName: String, branch: String, completion: @escaping (Result<Data,NetworkError>) -> Void) {
        _ = NetworkManager.standard.downloadData(url: RepositoryEndpoints.license(fullName, branch).url, completion: completion)
    }
    
    func getRepositoryReadme(fullName: String, branch: String, completion: @escaping (Result<Data,NetworkError>) -> Void) {
        _ = NetworkManager.standard.downloadData(url: RepositoryEndpoints.readme(fullName, branch).url, completion: completion)
    }
    
    // MARK: - Organization Search Methods
    
    func getOrganizationPage(page: Int, perPage: Int, completion: @escaping (Result<[OrganizationModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: OrganizationEndpoints.list(page, perPage).url, responseType: BatchResponse<OrganizationModel>.self) { result in
            switch result {
            case .success(let response): completion(.success(response.items))
            case .failure(let networkError): completion(.failure(networkError))
            }
        }
    }
    
    func getOrganizationSearchPage(keyword: String, page: Int, perPage: Int, completion: @escaping (Result<BatchResponse<OrganizationModel>,NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: OrganizationEndpoints.search(keyword, page, perPage).url, responseType: BatchResponse<OrganizationModel>.self, completion: completion)
    }
    
    // MARK: - Organization Methods
    
    func getOrganization(organizationLogin: String, completion: @escaping (Result<OrganizationModel,NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: OrganizationEndpoints.oragnization(organizationLogin).url, responseType: OrganizationModel.self, completion: completion)
    }
    
    func getOrganizationMemebers(organizationLogin: String, page: Int, perPage: Int, completion: @escaping (Result<[UserModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: OrganizationEndpoints.members(organizationLogin, page, perPage).url, responseType: [UserModel].self, completion: completion)
    }
    
    func getOrganizationRepositories(organizationLogin: String, page: Int, perPage: Int, completion: @escaping (Result<[RepositoryModel],NetworkError>) -> Void) {
        NetworkManager.standard.GETRequest(url: OrganizationEndpoints.repositories(organizationLogin, page, perPage).url, responseType: [RepositoryModel].self, completion: completion)
    }
    
    // MARK: - Download Methods
    
    func downloadImage(at url: URL, completion: @escaping (Result<Data,NetworkError>) -> Void) -> URLSessionDataTask {
        return NetworkManager.standard.downloadData(url: url) { result in
            completion(result)
        }
    }

}

extension GithubClient {
    
    private enum UserEndpoints {
        
        static let base = "https://api.github.com/users"
        static let authenticatedBase = "https://api.github.com/user"
        static let searchBase = "https://api.github.com/search/users?q="
        
        case user(String)
        case authenticatedUser
        case authenticatedUserFollow(String)
        case authenticatedUserStar(String)
        case list(Int,Int)
        case search(String,Int,Int)
        case followers(String,Int,Int)
        case following(String,Int,Int)
        case repositories(String,Int,Int)
        case organizations(String,Int,Int)
        case starred(String,Int,Int)
        
        var stringValue: String {
            switch self {
            case .user(let login): return UserEndpoints.base + "/" + login
            case .authenticatedUser: return UserEndpoints.authenticatedBase + "?"
            case .authenticatedUserFollow(let login): return UserEndpoints.authenticatedBase + "/following" + "/\(login)"
            case .authenticatedUserStar(let fullName): return UserEndpoints.authenticatedBase + "/starred" + "/" + fullName
            case .list(let page, let perPage): return UserEndpoints.searchBase + "followers:%3E10&page=\(page)&per_page=\(perPage)"
            case .search(let keyword, let page, let perPage): return UserEndpoints.searchBase + keyword + "&page=\(page)&per_page=\(perPage)"
            case .followers(let login, let page, let perPage): return UserEndpoints.base + "/" + login + "/followers" + "?page=\(page)&per_page=\(perPage)"
            case .following(let login, let page, let perPage): return UserEndpoints.base + "/" + login + "/following" + "?page=\(page)&per_page=\(perPage)"
            case .repositories(let login, let page, let perPage): return UserEndpoints.base + "/" + login + "/repos" + "?page=\(page)&per_page=\(perPage)"
            case .organizations(let login, let page, let perPage): return UserEndpoints.base + "/" + login + "/orgs" + "?page=\(page)&per_page=\(perPage)"
            case .starred(let login, let page, let perPage): return UserEndpoints.base + "/" + login + "/starred" + "?page=\(page)&per_page=\(perPage)"
            }
        }
        //.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    private enum RepositoryEndpoints {
        
        static let base = "https://api.github.com/repos"
        static let searchBase = "https://api.github.com/search/repositories?q="
        static let rawContentBase = "https://raw.githubusercontent.com"
        
        case repository(String)
        case list(Int,Int)
        case search(String,Int,Int)
        case stars(String,Int,Int)
        case forks(String,Int,Int)
        case contributors(String,Int,Int)
        case commits(String,Int,Int)
        case license(String,String)
        case readme(String,String)
        
        var stringValue: String {
            switch self {
            case .repository(let fullName): return RepositoryEndpoints.base + "/" + fullName
            case .list(let page, let perPage): return RepositoryEndpoints.searchBase + "stars:%3E10&page=\(page)&per_page=\(perPage)"
            case .search(let keyword, let page, let perPage): return RepositoryEndpoints.searchBase + keyword + "&page=\(page)&per_page=\(perPage)"
            case .stars(let fullName, let page, let perPage): return RepositoryEndpoints.base + "/" + fullName + "/stargazers" + "?page=\(page)&per_page=\(perPage)"
            case .forks(let fullName, let page, let perPage): return RepositoryEndpoints.base + "/" + fullName + "/forks" + "?page=\(page)&per_page=\(perPage)"
            case .contributors(let fullName, let page, let perPage): return RepositoryEndpoints.base + "/" + fullName + "/contributors" + "?page=\(page)&per_page=\(perPage)"
            case .commits(let fullName, let page, let perPage): return RepositoryEndpoints.base + "/" + fullName + "/commits" + "?page=\(page)&per_page=\(perPage)"
            case .license(let fullName, let branch): return RepositoryEndpoints.rawContentBase + "/" + fullName + "/" + branch + "/LICENSE"
            case .readme(let fullName, let branch): return RepositoryEndpoints.rawContentBase + "/" + fullName + "/" + branch + "/README.md"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    private enum OrganizationEndpoints {
        static let base = "https://api.github.com/orgs"
        static let searchBase = "https://api.github.com/search/users?q="
        
        case oragnization(String)
        case list(Int,Int)
        case search(String,Int,Int)
        case members(String, Int, Int)
        case repositories(String, Int, Int)
        
        var stringValue: String {
            switch self {
            case .oragnization(let organizationName): return OrganizationEndpoints.base + "/" + organizationName
            case .list(let page, let perPage): return OrganizationEndpoints.searchBase + "type:org+repos:%3E10&page=\(page)&per_page=\(perPage)"
            case .search(let keyword, let page, let perPage): return OrganizationEndpoints.searchBase + keyword + "type:org&page=\(page)&per_page=\(perPage)"
            case .members(let organizationName, let page, let perPage): return OrganizationEndpoints.base + "/" + organizationName + "/members" + "?page=\(page)&per_page=\(perPage)"
            case .repositories(let organizationName, let page, let perPage): return OrganizationEndpoints.base + "/" + organizationName + "/repos" + "?page=\(page)&per_page=\(perPage)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
}
