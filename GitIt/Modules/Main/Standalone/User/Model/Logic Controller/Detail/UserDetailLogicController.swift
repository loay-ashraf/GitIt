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
    var model = Observable<UserModel>()
    var parameter = String()
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<UserModel,NetworkError> {
        await webServiceClient.fetchUser(userLogin: parameter)
    }
    
    // MARK: - (Un)Bookmark Methods
    
    @MainActor func bookmark() -> Bool {
        if let _ = try? BookmarksManager.standard.add(model: modelObject) {
            return true
        }
        return false
    }
    
    @MainActor func unBookmark() -> Bool {
        if let _ = try? BookmarksManager.standard.delete(model: modelObject) {
            return true
        }
        return false
    }
    
    // MARK: - (Un)Follow Methods
    
    func follow() async -> Bool {
        return await webServiceClient.followUser(userLogin: modelObject.login) == nil ? true : false
    }
    
    func unFollow() async -> Bool {
        return await webServiceClient.unFollowUser(userLogin: modelObject.login) == nil ? true : false
    }
    
    // MARK: - Check For Status Methods
    
    func checkForStatus() async -> Array<Bool> {
        if NetworkManager.standard.isReachable, SessionManager.standard.sessionType == .authenticated {
            let isFollowed = await checkIfFollowed()
            let isBookmarked = await checkIfBookmarked()
            return [isBookmarked,isFollowed]
        } else {
            let isBookmarked = await checkIfBookmarked()
            return [isBookmarked,false]
        }
    }
    
    func checkIfBookmarked() async -> Bool {
        let fetchResult = await BookmarksManager.standard.check(model: modelObject)
        switch fetchResult {
        case true: return true
        case false: return false
        default: return false
        }
    }
    
    func checkIfFollowed() async -> Bool {
        return await webServiceClient.checkIfFollowingUser(userLogin: modelObject.login) == nil ? true : false
    }
    
}
