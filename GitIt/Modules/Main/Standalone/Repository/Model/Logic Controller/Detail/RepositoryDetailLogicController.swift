//
//  RepositoryDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import Foundation

final class RepositoryDetailLogicController: WebServiceDetailLogicController {
    
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = RepositoryModel
    
    var webServiceClient = GitHubClient()
    var model = Observable<RepositoryModel>()
    var parameter = String()
    
    // MARK: - load Method
    
    func load() async -> NetworkError? {
        if !parameter.isEmpty, !modelObject.isComplete {
            let dataError = processFetchResult(result: await fetchData())
            if dataError == nil {
                return processREADMEFetchResult(result: await fetchREADME())
            }
            return dataError
        }
        return nil
    }
    
    // MARK: - Fetch Data Methods
    
    func fetchData() async -> Result<RepositoryModel,NetworkError> {
        await webServiceClient.fetchRepository(fullName: parameter)
    }
    
    func fetchREADME() async -> DataResult {
        await webServiceClient.downloadRepositoryREADME(fullName: modelObject.fullName, branch: modelObject.defaultBranch)
    }
    
    // MARK: - Fetch Result Processing Method
    
    func processREADMEFetchResult(result: DataResult) -> NetworkError? {
        switch result {
        case .success(let response): modelObject.READMEString = String(data: response, encoding: .utf8)
                                     modelObject.isComplete = true
                                     return nil
        case .failure(let networkError): return networkError
        }
    }
    
    // MARK: - (Un)Bookmark Methods
    
    func bookmark() -> Bool {
        if let _ = try? BookmarksManager.standard.add(model: modelObject) {
            return true
        }
        return false
    }
    
    func unBookmark() -> Bool {
        if let _ = try? BookmarksManager.standard.delete(model: modelObject) {
            return true
        }
        return false
    }
    
    // MARK: - (Un)Star Methods
    
    func star() async -> Bool {
        return await webServiceClient.starRepository(fullName: modelObject.fullName) == nil ? true : false
    }
    
    func unStar() async -> Bool {
        return await webServiceClient.unStarRepository(fullName: modelObject.fullName) == nil ? true : false
    }
    
    // MARK: - Check For Status Methods
    
    func checkForStatus() async -> Array<Bool> {
        if NetworkManager.standard.isReachable, SessionManager.standard.sessionType == .authenticated {
            let isStarred = await checkIfStarred()
            let isBookmarked = self.checkIfBookmarked()
            return [isBookmarked,isStarred]
        } else {
            let isBookmarked = self.checkIfBookmarked()
            return [isBookmarked,false]
        }
    }

    func checkIfBookmarked() -> Bool {
        let fetchResult = BookmarksManager.standard.check(model: modelObject)
        switch fetchResult {
        case true: return true
        case false: return false
        default: return false
        }
    }
    
    func checkIfStarred() async -> Bool {
        return await webServiceClient.checkIfStarredRepository(fullName: modelObject.fullName) == nil ? true : false
    }
    
}
