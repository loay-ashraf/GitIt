//
//  CommonTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 12/11/2021.
//

import Foundation
import UIKit

struct List<Type> {
    
    var items: [Type] = []
    var isPaginable: Bool = false
    var currentPage: Int = 1
    
    var count: Int { return items.count }
    var isEmpty: Bool { return items.isEmpty }
    
    init() {}
    
    init(with items: [Type]) {
        self.items = items
    }
    
    mutating func reset() {
        items.removeAll()
        isPaginable = false
        currentPage = 1
    }
    
    mutating func insert(_ newElement: Type, at index: Int) {
        items.insert(newElement, at: index)
    }
    
    mutating func insert(contentsOf newElements: [Type], at index: Int) {
        items.insert(contentsOf: newElements, at: index)
    }
    
    mutating func append(_ newElement: Type) {
        items.append(newElement)
    }
    
    mutating func append(contentsOf: [Type]) {
        items.append(contentsOf: contentsOf)
    }
    
    mutating func remove(at index: Int) {
        items.remove(at: index)
    }
    
    mutating func removeAll(_ item: Type) where Type: Equatable {
        items.removeAll() { value in return value == item }
    }
    
}

enum UserContext {
    
    case main
    case followers
    case following
    case stars
    case contributors
    case members
    
    var titleValue: String {
        switch self {
        case .main: return Constants.View.Title.users.main
        case .followers: return Constants.View.Title.users.followers
        case .following: return Constants.View.Title.users.following
        case .stars: return Constants.View.Title.users.stargazers
        case .contributors: return Constants.View.Title.users.contributors
        case .members: return Constants.View.Title.users.members
        }
    }
    
    typealias FollowersParameters = (String,Int)
    typealias FollowingParameters = (String,Int)
    typealias StarsParameters = (String,Int)
    typealias ContributorsParameters = String
    typealias MembersParameters = String
    
}

enum RepositoryContext {
    
    case main
    case user
    case organization
    case forks
    case starred
    
    var titleValue: String {
        switch self {
        case .forks: return Constants.View.Title.repositories.forks
        case .starred: return Constants.View.Title.repositories.starred
        default: return Constants.View.Title.repositories.main
        }
    }
    
    typealias UserParameters = (String,Int)
    typealias OrganizationParameters = (String,Int)
    typealias ForksParameters = (String,Int)
    typealias StarredParameters = String
    
}

enum OrganizationContext {
    
    case main
    case user
    
    var titleValue: String {
        switch self {
        default: return Constants.View.Title.organizations.main
        }
    }
    
    typealias UserParameters = String
    
}

typealias LoadingHandler = (Error?) -> Void

enum ViewState {
    
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

enum SearchUIState {
    
    case idle
    case searching
    
}

enum SearchContext {
    
    case general
    case users
    case repositories
    case organizations
    
    var barPlaceholder: String {
        switch self {
        case .general: return Constants.View.SearchBar.general
        case .users: return Constants.View.SearchBar.users
        case .repositories: return Constants.View.SearchBar.repositories
        case .organizations: return Constants.View.SearchBar.organizations
        }
    }
    
    init?<Type: Model>(from modelType: Type.Type) {
        switch Type.self {
        case is UserModel.Type: self = .users
        case is RepositoryModel.Type: self = .repositories
        case is OrganizationModel.Type: self = .organizations
        default: self = .general
        }
    }
    
}

struct SearchHistory<Type: Model>: Codable {
    
    var models: [Type]
    var keywords: [String]
    
    mutating func clear() {
        models.removeAll()
        keywords.removeAll()
    }
    
    init() {
        models = []
        keywords = []
    }
    
}

enum BookmarksContext {
    
    case general
    case users
    case repositories
    case organizations
    
    init?<Type: Model>(from modelType: Type.Type) {
        switch Type.self {
        case is UserModel.Type: self = .users
        case is RepositoryModel.Type: self = .repositories
        case is OrganizationModel.Type: self = .organizations
        default: self = .general
        }
    }
    
}

enum Alert {
    
    case internetError
    case networkError
    case dataError
    case signInError
    case guestSignIn(() -> Void)
    case clearSearchHistory(() -> Void)
    case clearBookmarks(() -> Void)
    case clearData
    case signOut(() -> Void)
    
    var controller: UIAlertController {
        typealias alertConstants = Constants.View.Alert
        switch self {
        case .internetError: return alertConstants.InternetError.alertController()
        case .networkError: return alertConstants.NetworkError.alertController()
        case .dataError: return alertConstants.DataError.alertController()
        case .signInError: return alertConstants.SignInError.alertController()
        case .guestSignIn(let handler): return alertConstants.GuestSignIn.alertController(with: handler)
        case .clearSearchHistory(let handler): return alertConstants.ClearSearchHistory.alertController(with: handler)
        case .clearBookmarks(let handler): return alertConstants.ClearBookmarks.alertController(with: handler)
        case .clearData: return alertConstants.ClearData.alertController()
        case .signOut(let handler): return alertConstants.SignOut.alertController(with: handler)
        }
    }
    
}

struct ErrorViewModel {
    
    var image: UIImage?
    var title: String
    var message: String
    
    init(image: UIImage?, title: String, message: String) {
        self.image = image
        self.title = title
        self.message = message
    }
    
    init?(from error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noResponse,.noData: self = ErrorConstants.internet.viewModel
            case .client(let clientError): if (clientError as NSError).code == NSURLErrorNotConnectedToInternet {
                self = ErrorConstants.internet.viewModel
            } else {
                self = ErrorConstants.network.viewModel
            }
            case .server,.api,.decoding,.encoding: self = ErrorConstants.network.viewModel
            }
            return
        } else if error.self is DataError {
            self = ErrorConstants.data.viewModel
            return
        }
        return nil
    }
    
}

struct EmptyViewModel {
    
    var image: UIImage?
    var title: String
    
    init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
    }
    
}

enum SubviewsOffsetSize: CGFloat {
    
    typealias RawValue = CGFloat
    
    case mainScreen = 96.0
    case mainScreenWithSearch = 205.0
    case subScreen = 95.0
    case searchScreen = 88.0
    case searchScreenWithNavBar = 145.0
    
}


