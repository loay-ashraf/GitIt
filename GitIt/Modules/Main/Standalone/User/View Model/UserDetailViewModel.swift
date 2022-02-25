//
//  UserDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

final class UserDetailViewModel: WebServiceDetailViewModel {
    
    // MARK: - Properties
    
    typealias WebServiceLogicControllerType = UserDetailLogicController
    
    var logicController: UserDetailLogicController
    var handler: NetworkLoadingHandler?
    
    var login: String = ""
    var avatarURL: URL = URL(string: "www.github.com")!
    var htmlURL: URL = URL(string: "www.github.com")!
    var name: String?
    var bio: String?
    var company: String?
    var location: String?
    var blogURL: URL?
    var email: String?
    var twitter: String?
    var repositories: Int = 0
    var followers: Int = 0
    var following: Int = 0
    var isBookmarked: Bool = false
    var isFollowed: Bool = false
    
    // MARK: - Initialization
    
    init(withParameter parameter: String) {
        logicController = UserDetailLogicController(withParameter: parameter)
    }
    
    init(collectionCellViewModel: UserCollectionCellViewModel) {
        logicController = UserDetailLogicController(withParameter: collectionCellViewModel.login)
    }
    
    init(tableCellViewModel: UserTableCellViewModel) {
        logicController = UserDetailLogicController(withParameter: tableCellViewModel.login)
    }
    
    // MARK: - View Actions
    
    func toggleBookmark() -> Bool {
        if !isBookmarked {
            isBookmarked = logicController.bookmark()
        } else {
            isBookmarked = !logicController.unBookmark()
        }
        return isBookmarked
    }
    
    func toggleFollow() async -> Bool {
        if !isFollowed {
            isFollowed = await logicController.follow()
        } else {
            isFollowed = await !logicController.unFollow()
        }
        return isFollowed
    }
    
    // MARK: - Status Checking Method
    
    func checkForStatus() async -> Array<Bool> {
        let status = await logicController.checkForStatus()
        isBookmarked = status[0]
        isFollowed = status[1]
        return status
    }
    
    // MARK: - Synchronize Method
    
    func synchronize() {
        let model = logicController.model
        login = model.login
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        name = model.name
        bio = model.bio
        company = model.company
        location = model.location
        blogURL = model.blogURL
        email = model.email
        twitter = model.twitter
        repositories = model.repositories!
        followers = model.followers!
        following = model.following!
    }
    
}
