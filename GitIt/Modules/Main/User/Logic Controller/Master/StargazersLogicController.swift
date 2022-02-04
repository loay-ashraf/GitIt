//
//  StargazersLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/01/2022.
//

import Foundation

class StargazersLogicController: UserLogicController {
    
    // MARK: - Properties
    
    var repositoryFullName: String
    var numberofStargazers: Int
    
    // MARK: - Initialization
    
    init(repositoryFullName: String, numberofStargazers: Int) {
        self.repositoryFullName = repositoryFullName
        self.numberofStargazers = numberofStargazers
        super.init()
    }
    
    // MARK: - Loading Methods
    
    override func load(then handler: @escaping LoadingHandler) {
        self.handler = handler
        GitHubClient.fetchRepositoryStars(fullName: repositoryFullName, page: model.currentPage, completionHandler: processResult(result:))
    }
    
    // MARK: - Result Processing Methods
    
    override func updateModelParameters(newItemsCount: Int = 0) {
        super.updateModelParameters(newItemsCount: newItemsCount)
        model.isPaginable = model.items.count == numberofStargazers ? false : true
    }
    
}
