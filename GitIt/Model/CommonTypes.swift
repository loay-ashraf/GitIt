//
//  CommonTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 12/11/2021.
//

import Foundation
import UIKit

struct List<Type: Model>: Equatable {
    
    static func == (lhs: List<Type>, rhs: List<Type>) -> Bool {
        if lhs.items == rhs.items, lhs.isPaginable == rhs.isPaginable, lhs.currentPage == rhs.currentPage {
            return true
        }
        return false
    }
    
    var items: [Type] = []
    var isPaginable: Bool = false
    var currentPage: Int = 1
    
    mutating func reset() {
        items.removeAll()
        isPaginable = false
        currentPage = 1
    }
    
    mutating func append(_ newElement: Type) {
        items.append(newElement)
    }
    
    mutating func append(contentsOf: [Type]) {
        items.append(contentsOf: contentsOf)
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

typealias ViewStateHandler = (ViewState) -> Void
typealias ErrorHandler = (Error?) -> Void

enum ViewState {
    
    case loading(LoadingViewState)
    case presenting
    case failed(FailedViewState)
    
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

enum SearchViewState {
    
    case searching
    case notSearching
    case paginating
    case presenting
    case failed(Error)
    
}

enum ContextMenuActions<Type: Model> {
    
    case bookmark(Type)
    case unbookmark(Type)
    case share(Type)
    
    var action: UIAction {
        switch self {
            case .bookmark(let model): return UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark"), identifier: nil) { action in
                                                    _ = CoreDataManager.standard.insert(model)
                                                }
            
            case .unbookmark(let model): return UIAction(title: "Unbookmark", image: UIImage(systemName: "bookmark.fill"), identifier: nil) { action in
                                                   _ = CoreDataManager.standard.delete(model)
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
            case .client,.server,.api,.decoding,.encoding: self.init(image: UIImage(systemName: "exclamationmark.icloud"), title: "Network Error", message: "We're working on it,\nWe will be back soon.")
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


