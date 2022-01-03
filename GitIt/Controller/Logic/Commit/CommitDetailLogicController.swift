//
//  CommitDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import Foundation

class CommitDetailLogicController {
    
    var model: CommitModel
    
    // MARK: - Initialisation
    
    init(_ model: CommitModel) {
        self.model = model
    }
    
    // MARK: - Business Logic Methods
    
    func load(then handler: @escaping ErrorHandler) {
        handler(nil)
    }
    
}
