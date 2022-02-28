//
//  WebServiceViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import Foundation

// MARK: - Protocol Definition

protocol WebServiceViewModel: AnyObject {
    
    associatedtype WebServiceLogicControllerType: WebServiceLogicController
    
    var logicController: WebServiceLogicControllerType { get }

    init()
    
    func reset()
    func bindToModel()
    
}

protocol WebServiceDetailViewModel: AnyObject {
    
    associatedtype WebServiceLogicControllerType: WebServiceDetailLogicController
    
    var logicController: WebServiceLogicControllerType { get }

    init()
    init(withParameter parameter: String)
    
    func load() async -> NetworkError?
    func checkForStatus() async -> Array<Bool>
    func bindToModel()
    
}


protocol WebServicePlainViewModel: WebServiceViewModel where WebServiceLogicControllerType: WebServicePlainLogicController {
    
    func load() async -> NetworkError?
    func refresh() async -> NetworkError?
    func paginate() async -> NetworkError?
    
}

protocol WebServiceSearchViewModel: WebServiceViewModel where WebServiceLogicControllerType: WebServiceSearchLogicController {
    
    func search(withQuery query: String) async -> NetworkError?
    func refresh() async -> NetworkError?
    func paginate() async -> NetworkError?
    
}

// MARK: - Protocol Extensions

extension WebServiceViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
    // MARK: - Reset Method
    
    func reset() {
        logicController.resetData()
    }
    
}

extension WebServiceDetailViewModel {
    
    // MARK: - Initialization
    
    init() {
        self.init()
    }
    
    // MARK: - Load Method
    
    func load() async -> NetworkError? {
        await logicController.load()
    }
    
}

extension WebServicePlainViewModel {
    
    // MARK: - Load, Refresh and Paginate methods
    
    func load() async -> NetworkError? {
        await logicController.load()
    }
    
    func refresh() async -> NetworkError? {
        await logicController.refresh()
    }
    
    func paginate() async -> NetworkError? {
        await logicController.paginate()
    }
    
}

extension WebServiceSearchViewModel {
    
    // MARK: - Search, Refresh and Paginate methods
    
    func search(withQuery query: String) async -> NetworkError? {
        await logicController.search(withQuery: query)
    }
    
    func refresh() async -> NetworkError? {
        await logicController.refresh()
    }
    
    func paginate() async -> NetworkError? {
        await logicController.paginate()
    }
    
}
