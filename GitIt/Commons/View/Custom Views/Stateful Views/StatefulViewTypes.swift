//
//  StatefulViewTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import Foundation

enum ViewState: Equatable {

    case presenting
    case empty(EmptyViewModel)
    case loading(LoadingViewState)
    case failed(FailedViewState)
    
    func isTransionable(to viewState: ViewState) -> Bool {
        switch (self,viewState) {
        case (.presenting,.presenting): return false
        case (.presenting,.empty): return true
        case (.presenting,.loading): return true
        case (.presenting,.failed): return false
        case (.empty,.empty): return false
        case (.empty,.presenting): return true
        case (.empty,.loading): return false
        case (.empty,.failed): return false
        case (.loading,.loading): return false
        case (.loading,.presenting): return true
        case (.loading,.empty): return true
        case (.loading,.failed): return true
        case (.failed,.failed): return false
        case (.failed,.presenting): return false
        case (.failed,.empty): return false
        case (.failed,.loading): return true
        }
    }
    
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs,rhs) {
        case (.presenting,.presenting): return true
        case (.empty,.empty): return true
        case (.loading,.loading): return true
        case (.failed,.failed): return true
        default: return false
        }
    }
    
}

enum LoadingViewState {
    
    case initial
    case refresh
    case paginate
    
}

enum FailedViewState {
    
    case initial(Error)
    case refresh(Error)
    case paginate(Error)
    
}
