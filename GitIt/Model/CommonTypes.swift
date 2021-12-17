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

enum ViewState {
    
    case loading
    case paginating
    case presenting
    case failed(Error)
    
}

enum LicenseViewState {
    
    case loading
    case presenting
    case failed(Error)
    
}

enum UserDetailViewState {
    
    case loading
    case followed
    case bookmarked
    case presenting
    case failed(Error)
    
}

enum RepositoryDetailViewState {
    
    case loading
    case starred
    case bookmarked
    case presenting
    case failed(Error)
    
}

enum CommitDetailViewState {
    
    case loading
    case presenting
    case failed(Error)
    
}

enum OrganizationDetailViewState {
    
    case loading
    case bookmarked
    case presenting
    case failed(Error)
    
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
                                                    DataController.standard.insert(model)
                                                }
            
            case .unbookmark(let model): return UIAction(title: "Unbookmark", image: UIImage(systemName: "bookmark.fill"), identifier: nil) { action in
                                                    DataController.standard.delete(model)
                                                }
            
            case .share(let model): return UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) { action in
                                                    URLHelper.shareURL(model.htmlURL)
                                            }
        }
    }
    
}

enum ThemeType {
    
    case followSystem
    case light
    case dark
    
    var stringValue: String {
        switch self {
            case .followSystem: return "Follow System"
            case .light: return "Light"
            case .dark: return "Dark"
        }
    }
    
}

enum SessionType {
    
    case authenticated
    case guest
    case signedOut
    
    var stringValue: String {
        switch self {
            case .authenticated: return "authenticated"
            case .guest: return "guest"
            case .signedOut: return "signedOut"
        }
    }
    
}
