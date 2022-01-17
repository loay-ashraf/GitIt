//
//  Constants.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import Foundation
import UIKit
import CoreData
import Network

var subViewsOffsetSize: SubviewsOffsetSize!

struct Constants {
    
    // MARK: - Model Constants
    
    struct Model {
       
        static func modelToCellType<Type: GitIt.Model>(type: Type.Type) -> IBTableViewCell.Type? {
            switch type {
            case is UserModel.Type: return RoundedImageTableViewCell.self
            case is RepositoryModel.Type: return RepositoryTableViewCell.self
            case is OrganizationModel.Type: return RoundedImageTableViewCell.self
            case is CommitModel.Type: return CommitTableViewCell.self
            default: return nil
            }
        }
        
        static func modelToDetailViewControllerType<Type: GitIt.Model>(type: Type.Type) -> IBViewController.Type? {
            switch type {
            case is UserModel.Type: return UserDetailViewController.self
            case is RepositoryModel.Type: return RepositoryDetailViewController.self
            case is OrganizationModel.Type: return OrganizationDetailViewController.self
            case is CommitModel.Type: return CommitDetailViewController.self
            default: return nil
            }
        }
        
        static func contextMenuConfiguration<Type>(for model: Type) -> UIContextMenuConfiguration? {
            switch model {
            case let model as UserModel: return contextMenuConfiguration(forUserModel: model)
            case let model as RepositoryModel: return contextMenuConfiguration(forRepositoryModel: model)
            case let model as OrganizationModel: return contextMenuConfiguration(forOrganizationModel: model)
            case let model as CommitModel: return contextMenuConfiguration(forCommitModel: model)
            default: return nil
            }
        }
        
        static func contextMenuConfiguration(forUserModel model: UserModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = BookmarksManager.standard.check(model: model)
                switch fetchResult {
                case true: bookmark = ContextMenuActions.unbookmark(model).action
                case false: bookmark = ContextMenuActions.bookmark(model).action
                default: break
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func contextMenuConfiguration(forRepositoryModel model: RepositoryModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = BookmarksManager.standard.check(model: model)
                switch fetchResult {
                case true: bookmark = ContextMenuActions.unbookmark(model).action
                case false: bookmark = ContextMenuActions.bookmark(model).action
                default: break
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func contextMenuConfiguration(forOrganizationModel model: OrganizationModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = BookmarksManager.standard.check(model: model)
                switch fetchResult {
                case true: bookmark = ContextMenuActions.unbookmark(model).action
                case false: bookmark = ContextMenuActions.bookmark(model).action
                default: break
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func contextMenuConfiguration(forCommitModel model: CommitModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var share: UIAction! = nil
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "", children: [share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        struct SearchHistory {
            
            static let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("Search History")
            static let userURL = baseURL!.appendingPathComponent("UserSearchHistory.json")
            static let repositoryURL = baseURL!.appendingPathComponent("RepositorySearchHistory.json")
            static let organizationURL = baseURL!.appendingPathComponent("OrganizationSearchHistory.json")
            
        }
        
        struct Bookmarks {
            
        }
        
    }
    
    // MARK: - Services Constants
    
    struct Services {
        
        
    }
    
    // MARK: - View Constants
    
    struct View {
        
        struct Titles {
            
            struct users {
                
                // Users title strings
                static let main = "Users".localized()
                static let followers = "Followers".localized()
                static let following = "Following".localized()
                static let stargazers = "Stargazers".localized()
                static let contributors = "Contributors".localized()
                static let members = "Members".localized()
                
            }
            
            struct repositories {
                
                // Repositories title strings
                static let main = "Repositories".localized()
                static let forks = "Forks".localized()
                static let starred = "Starred".localized()
                
            }
             
            struct organizations {
                
                // Organizations title strings
                static let main = "Organizations".localized()
                
            }
            
            struct commits {
                
                // Commits title strings
                static let main = "Commits".localized()
                
            }
            
            static let settings = "Settings".localized()
            
        }
        
        struct SearchBar {
            
            // Search bar placeholder strings
            static let general = "Search...".localized()
            static let users = "Search All Users".localized()
            static let repositories = "Search All Repositories".localized()
            static let organizations = "Search All Organizations".localized()
            
        }
        
        struct ContextMenu {
            
            // Bookmark action image and title
            struct bookmark {
                
                static let image = UIImage(systemName: "bookmark")
                static let title = "Bookmark".localized()
                
            }
            
            // Unbookmark action image and title
            struct unBookmark {
                
                static let image = UIImage(systemName: "bookmark.fill")
                static let title = "Unbookmark".localized()
                
            }
            
            // Share action image and title
            struct share {
                
                static let image = UIImage(systemName: "square.and.arrow.up")
                static let title = "Share".localized()
                
            }
            
        }
        
        struct Alert {
            
            struct InternetError {
                
                static let title = "No Internet".localized()
                static let message = "You're not conntected to the internet, Can't connect to authentication server.".localized()
                
                static func alertController() -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    controller.addAction(Constants.View.Alert.okAction)
                    return controller
                }
                
            }
            
            struct NetworkError {
                
                static let title = "Network Error".localized()
                static let message = "We can't connect to server at time, switching to offline mode.".localized()
                
                static func alertController() -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    controller.addAction(Constants.View.Alert.okAction)
                    return controller
                }
                
            }
            
            struct DataError {
                
                static let title = "Data Error".localized()
                static let message = "We couldn't load your data, we're working on a fix for the issue.".localized()
                
                static func alertController() -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    controller.addAction(Constants.View.Alert.okAction)
                    return controller
                }
                
            }
            
            struct SignInError {
                
                static let title = "Sign In Error".localized()
                static let message = "An error occured while signing you in, please try again later.".localized()
                
                static func alertController() -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    controller.addAction(Constants.View.Alert.okAction)
                    return controller
                }
                
            }
            
            struct GuestSignIn {
                
                static let title = "Continue as a Guest?".localized()
                static let message = "If you continue as a guest, features will be limted. Do you want to proceed?".localized()
                static let continueActionTitle = "Continue".localized()
                
                static func alertController(with handler: @escaping () -> Void) -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                    controller.addAction(Constants.View.Alert.cancelAction)
                    controller.addAction(UIAlertAction(title: continueActionTitle, style: .default) { action in
                        handler()
                    } )
                    return controller
                }
                
            }
            
            struct ClearSearchHistory {
                
                static let title = "Clear search history?".localized()
                static let message = "This can't be undone and you'll remove your search history.".localized()
                static let clearActionTitle = "Clear History".localized()
                
                static func alertController(with handler: @escaping () -> Void) -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                    controller.addAction(Constants.View.Alert.cancelAction)
                    controller.addAction(UIAlertAction(title: clearActionTitle, style: .destructive) { action in
                        SearchHistoryManager.standard.clearActive()
                        handler()
                    } )
                    return controller
                }
                
            }
            
            struct ClearBookmarks {
                
                static let title = "Clear bookmarks?".localized()
                static let message = "This can't be undone and you'll remove your bookmarks.".localized()
                static let clearActionTitle = "Clear Bookmarks".localized()
                
                static func alertController(with handler: @escaping () -> Void) -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                    controller.addAction(Constants.View.Alert.cancelAction)
                    controller.addAction(UIAlertAction(title: clearActionTitle, style: .destructive) { action in
                        try? BookmarksManager.standard.clearActive()
                        handler()
                    } )
                    return controller
                }
                
            }
            
            struct ClearData {
                
                static let title = "Clear data?".localized()
                static let message = "You're about to erase your local data, proceed?".localized()
                static let clearActionTitle = "Clear Data".localized()
                
                static func alertController() -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                    controller.addAction(Constants.View.Alert.cancelAction)
                    controller.addAction(UIAlertAction(title: clearActionTitle, style: .destructive) { action in
                        try? DataManager.standard.clearData()
                    } )
                    return controller
                }
                
            }
            
            struct SignOut {
                
                static let title = "Sign Out?".localized()
                static let message = "If you sign out all of your data will be erased, continue?".localized()
                static let signOutActionTitle = "Sign Out".localized()
                
                static func alertController(with handler: @escaping () -> Void) -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
                    controller.addAction(Constants.View.Alert.cancelAction)
                    controller.addAction(UIAlertAction(title: signOutActionTitle, style: .destructive) { action in
                        handler()
                    } )
                    return controller
                }
                
            }
            
            static let okAction = UIAlertAction(title: "Ok".localized(), style: .cancel, handler: nil)
            static let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            
        }
        
        struct Error {
            
            // Internet error image, title and message
            struct internet {
                
                static private let image = UIImage(systemName: "wifi.exclamationmark")
                static private let title = "No Internet".localized()
                static private let message = "You're not connected to Internet,\nplease try again later.".localized()
                static let viewModel = ErrorViewModel(image: image, title: title, message: message)

            }
            
            // Network error image, title and message
            struct network {
                
                static private let image = UIImage(systemName: "exclamationmark.icloud")
                static private let title = "Network Error".localized()
                static private let message = "We're working on it,\nWe will be back soon.".localized()
                static let viewModel = ErrorViewModel(image: image, title: title, message: message)
                
            }
            
            // Data error image, title and message
            struct data {
                
                static private let image = UIImage(systemName: "externaldrive.badge.xmark")
                static private let title = "Couldn't Retrieve Data".localized()
                static private let message = "We're working on it,\nWe will be back soon.".localized()
                static let viewModel = ErrorViewModel(image: image, title: title, message: message)
                
            }
            
        }
        
        struct Empty {
            
            // General empty image and title
            struct general {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "WoW, such empty".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Users empty image and title
            struct users {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "There isn't any users.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Repositories empty image and title
            struct repositories {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "There isn't any repositories.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Organizations empty image and title
            struct organizations {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "There isn't any organizations.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Commits empty image and title
            struct commits {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "There isn't any commits.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Search history empty image and title
            struct searchHistory {
                
                static private let image = UIImage(systemName: "magnifyingglass")
                static private let title = "No Search history found, try searching first.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Search results image and title
            struct searchResults {
                
                static private let image = UIImage(systemName: "magnifyingglass")
                static private let title = "No Search results found, try searching for a different term.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Bookmarks image and title
            struct bookmarks {
                
                static private let image = UIImage(systemName: "bookmark.slash")
                static private let title = "No Bookmarks found.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
        }
        
        struct Label {
            
            static let guest = "Signed in as a Guest".localized()
            static let signIn = "Sign in with your Github account to enable extended features.".localized()
            
        }
        
        struct Button {
            
            struct follow {
                
                static let defaultTitle = "Follow".localized()
                static let defaultImage = UIImage(systemName: "plus")
                static let followedTitle = "Followed".localized()
                static let followedImage = UIImage(systemName: "checkmark")
                
            }
            
            struct star {
                
                static let defaultTitle = "Star".localized()
                static let defaultImage = UIImage(systemName: "star")
                static let starredTitle = "Starred".localized()
                static let starredImage = UIImage(systemName: "star.fill")
                
            }
            
            struct bookmark {
                
                static let defaultImage = UIImage(systemName: "bookmark")
                static let bookmarkedImage = UIImage(systemName: "bookmark.fill")
                
            }
            
        }
        
        struct Image {
            
            static let guest = UIImage(systemName: "person")
            
        }
        
    }
    
}
