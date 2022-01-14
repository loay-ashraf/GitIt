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
        case .main: return Constants.View.titles.users.main
        case .followers: return Constants.View.titles.users.followers
        case .following: return Constants.View.titles.users.following
        case .stars: return Constants.View.titles.users.stargazers
        case .contributors: return Constants.View.titles.users.contributors
        case .members: return Constants.View.titles.users.members
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
        case .forks: return Constants.View.titles.repositories.forks
        case .starred: return Constants.View.titles.repositories.starred
        default: return Constants.View.titles.repositories.main
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
        default: return Constants.View.titles.organizations.main
        }
    }
    
    typealias UserParameters = String
    
}

typealias LoadingHandler = (Error?,EmptyContext?) -> Void
typealias ErrorHandler = (Error?) -> Void

enum ViewState {
    
    case presenting
    case empty(EmptyContext)
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
        case .general: return Constants.View.searchBar.general
        case .users: return Constants.View.searchBar.users
        case .repositories: return Constants.View.searchBar.repositories
        case .organizations: return Constants.View.searchBar.organizations
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

enum ContextMenuActions<Type: Model> {
    
    case bookmark(Type)
    case unbookmark(Type)
    case share(Type)
    
    var action: UIAction {
        let title: String
        let image: UIImage?
        let handler: UIAction
        switch self {
        case .bookmark(let model): title = Constants.View.contextMenu.bookmark.title
                                   image = Constants.View.contextMenu.bookmark.image
                                    handler = UIAction(title: title, image: image, identifier: nil) { action in
                                    try? BookmarksManager.standard.add(model: model)
                                    }
        case .unbookmark(let model): title = Constants.View.contextMenu.unBookmark.title
                                     image = Constants.View.contextMenu.unBookmark.image
                                     handler = UIAction(title: title, image: image, identifier: nil) { action in
                                     try? BookmarksManager.standard.delete(model: model)
                                     }
        case .share(let model): title = Constants.View.contextMenu.share.title
                                image = Constants.View.contextMenu.share.image
                                handler = UIAction(title: title, image: image, identifier: nil) { action in
                                    URLHelper.shareURL(model.htmlURL)
                                }
        }
        return handler
    }
    
}

struct ErrorModel {
    
    var image: UIImage?
    var title: String
    var message: String
    
    private init(image: UIImage?, title: String, message: String) {
        self.image = image
        self.title = title
        self.message = message
    }
    
    init?(from error: Error) {
        let image: UIImage?
        let title: String
        let message: String
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noResponse,.noData: image = Constants.View.error.internet.image
                                      title = Constants.View.error.internet.title
                                      message = Constants.View.error.internet.message
            case .client(let clientError): if (clientError as NSError).code == NSURLErrorNotConnectedToInternet {
                image = Constants.View.error.internet.image
                title = Constants.View.error.internet.title
                message = Constants.View.error.internet.message
            } else {
                image = Constants.View.error.network.image
                title = Constants.View.error.network.title
                message = Constants.View.error.network.message
            }
            case .server,.api,.decoding,.encoding: image = Constants.View.error.network.image
                                                   title = Constants.View.error.network.title
                                                   message = Constants.View.error.network.message
            }
            self.init(image: image, title: title, message: message)
        } else if error.self is DataError || error.self is CoreDataError {
            image = Constants.View.error.data.image
            title = Constants.View.error.data.title
            message = Constants.View.error.data.message
            self.init(image: image, title: title, message: message)
        }
        return nil
    }
    
}

struct EmptyModel {
    
    var image: UIImage?
    var title: String
    
    init(image: UIImage?, title: String) {
        self.image = image
        self.title = title
    }
    
}

enum EmptyContext {
    
    case user
    case repository
    case organization
    case commit
    case searchHistory
    case searchResults
    case bookmarks
    
    var model: EmptyModel {
        let image: UIImage?
        let title: String
        switch self {
        case .user: image = Constants.View.empty.users.image
                    title = Constants.View.empty.users.title
        case .repository: image = Constants.View.empty.repositories.image
                          title = Constants.View.empty.repositories.title
        case .organization: image = Constants.View.empty.organizations.image
                            title = Constants.View.empty.organizations.title
        case .commit: image = Constants.View.empty.commits.image
                      title = Constants.View.empty.commits.title
        case .searchHistory: image = Constants.View.empty.searchHistory.image
                             title = Constants.View.empty.searchHistory.title
        case .searchResults: image = Constants.View.empty.searchResults.image
                             title = Constants.View.empty.searchHistory.title
        case .bookmarks: image = Constants.View.empty.bookmarks.image
                         title = Constants.View.empty.bookmarks.title
        }
        let model = EmptyModel(image: image, title: title)
        return model
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


