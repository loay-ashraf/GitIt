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
        case .main: return "Users"
        case .followers: return "Followers"
        case .following: return "Following"
        case .stars: return "Stargazers"
        case .contributors: return "Contributors"
        case .members: return "Members"
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
        case .forks: return "Forks"
        case .starred: return "Starred"
        default: return "Repositories"
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
        default: return "Organizations"
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

enum ContextMenuActions<Type: Model> {
    
    case bookmark(Type)
    case unbookmark(Type)
    case share(Type)
    
    var action: UIAction {
        switch self {
            case .bookmark(let model): return UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark"), identifier: nil) { action in
                                                    _ = BookmarksManager.standard.addBookmark(model: model)
                                                }
            
            case .unbookmark(let model): return UIAction(title: "Unbookmark", image: UIImage(systemName: "bookmark.fill"), identifier: nil) { action in
                                                    _ = BookmarksManager.standard.deleteBookmark(model: model)
                                                }
            
            case .share(let model): return UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) { action in
                                                URLHelper.shareURL(model.htmlURL)
                                            }
        }
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
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noResponse,.noData: self.init(image: UIImage(systemName: "wifi.exclamationmark"), title: "No Internet", message: "You're not connected to Internet,\nplease try again later.")
            case .client(let clientError): if (clientError as NSError).code == NSURLErrorNotConnectedToInternet {
                self.init(image: UIImage(systemName: "wifi.exclamationmark"), title: "No Internet", message: "You're not connected to Internet,\nplease try again later.")
            } else {
                self.init(image: UIImage(systemName: "exclamationmark.icloud"), title: "Network Error", message: "We're working on it,\nWe will be back soon.")
            }
            case .server,.api,.decoding,.encoding: self.init(image: UIImage(systemName: "exclamationmark.icloud"), title: "Network Error", message: "We're working on it,\nWe will be back soon.")
            }
        } else if let libraryError = error as? LibraryError {
            self.init(image: UIImage(systemName: "externaldrive.badge.xmark"), title: "Couldn't Retrieve Data", message: "We're working on it,\nWe will be back soon.")
        } else if let coreDataError = error as? CoreDataError {
            self.init(image: UIImage(systemName: "externaldrive.badge.xmark"), title: "Couldn't Retrieve Data", message: "We're working on it,\nWe will be back soon.")
        } else {
            return nil
        }
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
        switch self {
        case .user: return EmptyModel(image: UIImage(systemName: "exclamationmark"), title: "Looks like there's no Users in here.")
        case .repository: return EmptyModel(image: UIImage(systemName: "exclamationmark"), title: "Looks like there's no Repositories in here.")
        case .organization: return EmptyModel(image: UIImage(systemName: "exclamationmark"), title: "Looks like this User is not a member of any Organization.")
        case .commit: return EmptyModel(image: UIImage(systemName: "exclamationmark"), title: "Looks like there's no Commits yet for this repository.")
        case .searchHistory: return EmptyModel(image: UIImage(systemName: "magnifyingglass"), title: "No Search history found, try searching first.")
        case .searchResults: return EmptyModel(image: UIImage(systemName: "magnifyingglass"), title: "No Search results found, try searching for a different term.")
        case .bookmarks: return EmptyModel(image: UIImage(systemName: "bookmark.slash"), title: "No Bookmarks found.")
        }
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


