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
        bindToModel()
    }
    
    init(collectionCellViewModel: UserCollectionCellViewModel) {
        logicController = UserDetailLogicController(withParameter: collectionCellViewModel.login)
        bindToModel()
    }
    
    init(tableCellViewModel: UserTableCellViewModel) {
        logicController = UserDetailLogicController(withParameter: tableCellViewModel.login)
        bindToModel()
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
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] modelObject in
            if let modelObject = modelObject {
                self?.login = modelObject.login
                self?.avatarURL = modelObject.avatarURL
                self?.htmlURL = modelObject.htmlURL
                self?.name = modelObject.name
                self?.bio = modelObject.bio
                self?.company = modelObject.company
                self?.location = modelObject.location
                self?.blogURL = modelObject.blogURL
                self?.email = modelObject.email
                self?.twitter = modelObject.twitter
                self?.repositories = modelObject.repositories!
                self?.followers = modelObject.followers!
                self?.following = modelObject.following!
            }
        }
    }
    
}
