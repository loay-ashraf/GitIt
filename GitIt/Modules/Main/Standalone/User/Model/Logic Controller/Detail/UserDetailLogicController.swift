//
//  UserDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/11/2021.
//

import Foundation

final class UserDetailLogicController: WebServiceDetailLogicController {
   
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = UserModel
    
    var webServiceClient = GitHubClient()
    var model = UserModel()
    var parameter = String()
    var handler: NetworkLoadingHandler?
    
    // MARK: - Fetch Data Method
    
    func fetchData() {
        webServiceClient.fetchUser(userLogin: parameter, completion: processFetchResult(result:))
    }
    
    // MARK: - (Un)Bookmark Methods
    
    func bookmark(then handler: @escaping () -> Void) {
        if let _ = try? BookmarksManager.standard.add(model: model) {
            handler()
        }
    }
    
    func unBookmark(then handler: @escaping () -> Void) {
        if let _ = try? BookmarksManager.standard.delete(model: model) {
            handler()
        }
    }
    
    // MARK: - (Un)Follow Methods
    
    func follow(then handler: @escaping () -> Void) {
        webServiceClient.followUser(userLogin: model.login) { error in
            guard error != nil else {
                handler()
                return
            }
        }
    }
    
    func unFollow(then handler: @escaping () -> Void) {
        webServiceClient.unFollowUser(userLogin: model.login) { error in
            guard error != nil else {
                handler()
                return
            }
        }
    }
    
    // MARK: - Check For Status Methods
    
    func checkForStatus(then handler: @escaping ([Bool]) -> Void) {
        if NetworkManager.standard.isReachable, SessionManager.standard.sessionType == .authenticated {
            checkIfFollowed { isFollowed in
                let isBookmarked = self.checkIfBookmarked()
                handler([isBookmarked,isFollowed])
            }
        } else {
            let isBookmarked = self.checkIfBookmarked()
            handler([isBookmarked,false])
        }
    }
    
    func checkIfBookmarked() -> Bool {
        let fetchResult = BookmarksManager.standard.check(model: model)
        switch fetchResult {
        case true: return true
        case false: return false
        default: return false
        }
    }
    
    func checkIfFollowed(then handler: @escaping (Bool) -> Void) {
        webServiceClient.checkIfFollowingUser(userLogin: model.login) { error in
            guard error != nil else {
                handler(true)
                return
            }
            handler(false)
        }
    }
    
}
