//
//  Constants.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import Foundation
import UIKit

var subViewsOffsetSize: SubviewsOffsetSize!

struct Constants {
    
    struct Model {
       
        static func modelToCellType<Type: GitIt.Model>(type: Type.Type) -> IBTableViewCell.Type? {
            switch type {
            case is UserModel.Type: return UserTableViewCell.self
            case is RepositoryModel.Type: return RepositoryTableViewCell.self
            case is OrganizationModel.Type: return OrganizationTableViewCell.self
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
        
        static func modelToContextMenuConfiguration<Type>(type: Type.Type, for model: Type) -> UIContextMenuConfiguration? {
            switch type {
            case is UserModel.Type: return modelContextMenuConfiguration(for: model as! UserModel)
            case is RepositoryModel.Type: return modelContextMenuConfiguration(for: model as! RepositoryModel)
            case is OrganizationModel.Type: return modelContextMenuConfiguration(for: model as! OrganizationModel)
            case is CommitModel.Type: return modelContextMenuConfiguration(for: model as! CommitModel)
            default: return nil
            }
        }
        
        static func modelContextMenuConfiguration(for model: UserModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = BookmarksManager.standard.checkBookmark(model: model)
                switch fetchResult {
                case true: bookmark = ContextMenuActions.unbookmark(model).action
                case false: bookmark = ContextMenuActions.bookmark(model).action
                default: break
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "Quick Actions", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func modelContextMenuConfiguration(for model: RepositoryModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = BookmarksManager.standard.checkBookmark(model: model)
                switch fetchResult {
                case true: bookmark = ContextMenuActions.unbookmark(model).action
                case false: bookmark = ContextMenuActions.bookmark(model).action
                default: break
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "Quick Actions", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func modelContextMenuConfiguration(for model: OrganizationModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var bookmark: UIAction! = nil
                var share: UIAction! = nil
                let fetchResult = BookmarksManager.standard.checkBookmark(model: model)
                switch fetchResult {
                case true: bookmark = ContextMenuActions.unbookmark(model).action
                case false: bookmark = ContextMenuActions.bookmark(model).action
                default: break
                }
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "Quick Actions", children: [bookmark, share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
        static func modelContextMenuConfiguration(for model: CommitModel) -> UIContextMenuConfiguration {
            let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                var share: UIAction! = nil
                share = ContextMenuActions.share(model).action
                return UIMenu(title: "Quick Actions", children: [share])
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
        }
        
    }
    
    struct view {
        
        struct titles {
            
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
        
        struct searchBar {
            
            // Search bar placeholder strings
            static let general = "Search...".localized()
            static let users = "Search All Users".localized()
            static let repositories = "Search All Repositories".localized()
            static let organizations = "Search All Organizations".localized()
            
        }
        
        struct contextMenu {
            
            // Bookmark action image and title
            struct bookmark {
                
                static let image = UIImage(systemName: "bookmark")
                static let title = "Bookmark".localized()
                
            }
            
            // Unbookmark action image and title
            struct unBookmark {
                
                static let image = UIImage(systemName: "bookmark.fill")
                static let title = "Bookmark".localized()
                
            }
            
            // Share action image and title
            struct share {
                
                static let image = UIImage(systemName: "square.and.arrow.up")
                static let title = "Share".localized()
                
            }
            
        }
        
        struct alert {
            
            struct noInternetError {
                
                static let title = "No Internet".localized()
                static let message = "You're not conntected to the internet, Can't connect to authentication server.".localized()
                
            }
            
            struct startupError {
                
                static let title = "Network Error".localized()
                static let message = "We can't connect to server at time, would you like to rety or exit?".localized()
                static let retryActionTitle = "Retry".localized()
                static let exitActionTitle = "Exit".localized()
                
            }
            
            struct bookmarksError {
                
                static let title = "Data Error".localized()
                static let message = "We couldn't load your saved bookmarks, we're working on a fix for the issue.".localized()
                
            }
            
            struct signInError {
                
                static let title = "Sign In Error".localized()
                static let message = "An error occured while signing you in, please try again later.".localized()
                
            }
            
            struct guestSignIn {
                
                static let title = "Continue As a Guest?".localized()
                static let message = "If you continue as a guest, features will be limted. Do you want to proceed?".localized()
                static let continueActionTitle = "Continue".localized()
                
            }
            
            struct clearSearchHistory {
                
                static let title = "Clear search history?".localized()
                static let message = "This can't be undone and you'll remove your search history.".localized()
                static let clearActionTitle = "Clear History".localized()
                
            }
            
            struct clearData {
                
                static let title = "Clear Data?".localized()
                static let message = "You're about to erase your local data, proceed?".localized()
                static let clearActionTitle = "Clear Data".localized()
                
            }
            
            struct signOut {
                
                static let title = "Sign Out?".localized()
                static let message = "If you sign out all of your data will be erased, continue?".localized()
                static let signOutActionTitle = "Sign Out".localized()
                
            }
            
            static let okAction = UIAlertAction(title: "Ok".localized(), style: .cancel, handler: nil)
            static let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
            
        }
        
        struct error {
            
            // Internet error image, title and message
            struct internet {
                
                static let image = UIImage(systemName: "wifi.exclamationmark")
                static let title = "No Internet".localized()
                static let message = "You're not connected to Internet,\nplease try again later.".localized()

            }
            
            // Network error image, title and message
            struct network {
                
                static let image = UIImage(systemName: "exclamationmark.icloud")
                static let title = "Network Error".localized()
                static let message = "We're working on it,\nWe will be back soon.".localized()
                
            }
            
            // Data error image, title and message
            struct data {
                
                static let image = UIImage(systemName: "externaldrive.badge.xmark")
                static let title = "Couldn't Retrieve Data".localized()
                static let message = "We're working on it,\nWe will be back soon.".localized()
                
            }
            
        }
        
        struct empty {
            
            // Users empty image and title
            struct users {
                
                static let image = UIImage(systemName: "exclamationmark")
                static let title = "Looks like there's no Users in here.".localized()
                
            }
            
            // Repositories empty image and title
            struct repositories {
                
                static let image = UIImage(systemName: "exclamationmark")
                static let title = "Looks like there's no Repositories in here.".localized()
                
            }
            
            // Organizations empty image and title
            struct organizations {
                
                static let image = UIImage(systemName: "exclamationmark")
                static let title = "Looks like this User is not a member of any Organization.".localized()
                
            }
            
            // Commits empty image and title
            struct commits {
                
                static let image = UIImage(systemName: "exclamationmark")
                static let title = "Looks like there's no Commits yet for this repository.".localized()
                
            }
            
            // Search history empty image and title
            struct searchHistory {
                
                static let image = UIImage(systemName: "magnifyingglass")
                static let title = "No Search history found, try searching first.".localized()
                
            }
            
            // Search results image and title
            struct searchResults {
                
                static let image = UIImage(systemName: "magnifyingglass")
                static let title = "No Search results found, try searching for a different term.".localized()
                
            }
            
            // Bookmarks image and title
            struct bookmarks {
                
                static let image = UIImage(systemName: "bookmark.slash")
                static let title = "No Bookmarks found.".localized()
                
            }
            
        }
        
        struct button {
            
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
        
    }
    
}
