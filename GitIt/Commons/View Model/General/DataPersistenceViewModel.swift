//
//  DataPersistenceViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

protocol DataPersistenceViewModel: AnyObject {
    
    associatedtype LogicControllerType: DataPersistenceLogicController
    
    var logicController: LogicControllerType { get }
    
    init()

    func bindToModel()
    
}
