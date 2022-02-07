//
//  CommitDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import Foundation

class CommitDetailLogicController {
    
    // MARK: - Properties
    
    var model = CommitModel()
    
    // MARK: - Initialization

    init(model: CommitModel) {
        self.model = model
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        handler(nil)
    }
    
}
