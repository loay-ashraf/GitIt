//
//  Constants.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import Foundation
import UIKit
import NotificationBannerSwift
import SVProgressHUD
import Kingfisher
import CoreData
import Network

struct BasicCellActionProvider {
    
    var isBookmarked: Bool
    var toggleBookmark: () -> Void
    var saveImage: () -> Void
    var openInSafari: () -> Void
    var share: () -> Void
    
}

// MARK: - Constants Shortcuts

// Model Shortcuts
typealias ModelConstants = Constants.Model
typealias UserConstants = ModelConstants.User
typealias RepositoryConstants = ModelConstants.Repository
typealias OrganizationConstants = ModelConstants.Organization
typealias CommitConstants = ModelConstants.Commit
typealias SearchHistoryConstants = ModelConstants.SearchHistory
typealias NetworkingConstants = ModelConstants.Networking
typealias AuthenticationConstants = NetworkingConstants.Authentication
// View Shortcuts
typealias ViewConstants = Constants.View
typealias TitleConstants = ViewConstants.Title
typealias NavigayionBarConstants = ViewConstants.NavigationBar
typealias SearchBarConstants = ViewConstants.SearchBar
typealias ContextMenuConstants = ViewConstants.ContextMenu
typealias ContextMenuActionConstants = ContextMenuConstants.Actions
typealias ContextMenuConfigurationConstants = ContextMenuConstants.Configurations
typealias AlertConstants = ViewConstants.Alert
typealias ErrorConstants = ViewConstants.Error
typealias EmptyConstants = ViewConstants.Empty
typealias LabelConstants = ViewConstants.Label
typealias ButtonConstants = ViewConstants.Button
typealias ImageConstants = ViewConstants.Image
typealias TableViewConstants = ViewConstants.TableView
typealias TableViewDataSourceConstants = TableViewConstants.CustomComponents.DataSource
typealias TableViewDelegateConstants = TableViewConstants.CustomComponents.Delegate
typealias TableViewCellConfiguratorConstants = TableViewConstants.CustomComponents.CellConfigurator
typealias TableViewContextMenuConfiguratorConstants = TableViewConstants.CustomComponents.ContextMenuConfigurator
typealias TableViewTapResponderConstants = TableViewConstants.CustomComponents.TapResponder
typealias TableViewSwipeResponderConstants = TableViewConstants.CustomComponents.SwipeResponder
typealias CollectionViewConstants = ViewConstants.CollectionView
typealias CollectionViewDataSourceConstants = CollectionViewConstants.CustomComponents.DataSource
typealias CollectionViewDelegateConstants = CollectionViewConstants.CustomComponents.Delegate
typealias CollectionViewCellConfiguratorConstants = CollectionViewConstants.CustomComponents.CellConfigurator
typealias CollectionViewContextMenuConfiguratorConstants = CollectionViewConstants.CustomComponents.ContextMenuConfigurator
typealias CollectionViewTapResponderConstants = CollectionViewConstants.CustomComponents.TapResponder

struct Constants {
    
    // MARK: - Model Constants
    
    struct Model {
       
        struct User {
            
            
        }
        
        struct Repository {
            
            
        }
        
        struct Organization {
            
            
        }
        
        struct Commit {
            
            
        }
        
        struct SearchHistory {
            
            static let baseURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("Search History")
            static let userURL = baseURL!.appendingPathComponent("UserSearchHistory.json")
            static let repositoryURL = baseURL!.appendingPathComponent("RepositorySearchHistory.json")
            static let organizationURL = baseURL!.appendingPathComponent("OrganizationSearchHistory.json")
            
        }
        
        struct Bookmarks {
            
        }
        
        struct Networking {
            
            struct Authentication {
                
                static let clientID = "xxxxxxxxxxxxxxxxxxxxxxxxx"
                static let clientSecret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
                static let authorizationURL: URL = {
                    var urlComponents = URLComponents(string: "https://github.com/login/oauth/authorize")
                    urlComponents?.queryItems = [URLQueryItem(name: "client_id", value: clientID)]
                    return (urlComponents?.url)!
                }()
                static let tokenExchangeURL: URL = URL(string: "https://github.com/login/oauth/access_token")!
                static let callbackURLScheme = "gitit"
                
            }
            
            static let apiBaseUrl = "https://api.github.com/"
            static let rawContentBaseURL = "https://raw.githubusercontent.com"
            
            static let authenticatedUser = "user"
            static let authenticatedUserFollowing = "user/following"
            static let authenticatedUserStarred = "user/starred"
            
            static let users = "users"
            static let followers = "followers"
            static let following = "following"
            static let contributors = "contributors"
            static let members = "members"
            
            static let repositories = "repos"
            static let starred = "starred"
            static let stars = "stars"
            static let stargazers = "stargazers"
            static let forks = "forks"
            static let commits = "commits"
            static let license = "LICENSE"
            static let readme = "README.md"
            
            static let organizations = "orgs"
            static let organization = "org"
            
            static let search = "search"
            static let searchUsers = "search/users"
            static let searchRepositories = "search/repositories"
            static let searchOrganizations = "search/users"
            static let type = "type"
            
            static let query = "q"
            static let sort = "sort"
            static let order = "order"
            static let page = "page"
            static let perPage = "per_page"
            static let total_pages = "total_pages"
            
            static let contentType = "Content-Type"
            static let contentLength = "Content-Length"
            
            static let created = "created"
            static let ascending = "asc"
            static let descending = "desc"
            static let maxPageCount = 1000
            static let minimumPageCapacity = 20
            
        }
        
    }
    
    // MARK: - Services Constants
    
    struct Services {
        
        
    }
    
    // MARK: - View Constants
    
    struct View {
        
        // MARK: - Title Constants
        
        struct Title {
            
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
                static let trending = "Trending".localized()
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
        
        // MARK: - Navigation Bar Constants
        
        struct NavigationBar {
            
            static func configureAppearance(for navigationBar: UINavigationBar?) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.titleTextAttributes[.foregroundColor] = UIColor.white
                appearance.largeTitleTextAttributes[.foregroundColor] = UIColor.white
                appearance.backgroundColor = UIColor(named: "AccentColor")
                navigationBar?.standardAppearance = appearance
                navigationBar?.scrollEdgeAppearance = appearance
                navigationBar?.tintColor = .white
            }
            
        }
        
        // MARK: - Search Bar Constants
        
        struct SearchBar {
            
            // Search bar placeholder strings
            static let general = "Search...".localized()
            static let users = "Search All Users".localized()
            static let repositories = "Search All Repositories".localized()
            static let organizations = "Search All Organizations".localized()
            
        }
        
        // MARK: - Context Menu Constants
        
        struct ContextMenu {
            
            // MARK: - Context Menu Actions Constants
            
            struct Actions {
                
                // Delete action image and title
                struct Delete {
        
                    static let image = UIImage(systemName: "trash")
                    static let title = "Delete".localized()
                    static func action(with deleteAction: @escaping () -> Void) -> UIAction {
                        return UIAction(title: title, image: image, attributes: [.destructive]) { action in
                            deleteAction()
                        }
                    }
                    
                }
                
                // Bookmark action image and title
                struct Bookmark {
                    
                    static let image = UIImage(systemName: "bookmark")
                    static let title = "Bookmark".localized()
                    static func action(with bookamrkAction: @escaping () -> Void) -> UIAction {
                        return UIAction(title: title, image: image, attributes: []) { action in
                            bookamrkAction()
                        }
                    }
                    
                }
                
                // Unbookmark action image and title
                struct UnBookmark {
                    
                    static let image = UIImage(systemName: "bookmark.fill")
                    static let title = "Unbookmark".localized()
                    static func action(with unBookamrkAction: @escaping () -> Void) -> UIAction {
                        return UIAction(title: title, image: image, attributes: []) { action in
                            unBookamrkAction()
                        }
                    }
                    
                }
                
                // Save Image action image and title
                struct SaveImage {
        
                    static let image = UIImage(systemName: "square.and.arrow.down")
                    static let title = "Save Image".localized()
                    static func action(with saveImageAction: @escaping () -> Void) -> UIAction {
                        return UIAction(title: title, image: image, attributes: []) { action in
                            saveImageAction()
                        }
                    }
                    
                }
                
                // Open In Safari action image and title
                struct OpenInSafari {
        
                    static let image = UIImage(systemName: "safari")
                    static let title = "Open In Safari".localized()
                    static func action(with openInSafariAction: @escaping () -> Void) -> UIAction {
                        return UIAction(title: title, image: image, attributes: []) { action in
                            openInSafariAction()
                        }
                    }
                    
                }
                
                // Share action image and title
                struct Share {
                    
                    static let image = UIImage(systemName: "square.and.arrow.up")
                    static let title = "Share".localized()
                    static func action(with shareAction: @escaping () -> Void) -> UIAction {
                        return UIAction(title: title, image: image, attributes: []) { action in
                            shareAction()
                        }
                    }
                    
                }
                
            }
            
            // MARK: - Context Menu Configurations Constants
            
            struct Configurations {
                
                static func DeleteConfiguration(deleteAction: @escaping () -> Void) -> UIContextMenuConfiguration {
                    let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                        let delete = ContextMenuActionConstants.Delete.action(with: deleteAction)
                        return UIMenu(title: "", children: [delete])
                    }
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
                }
                
                static func SaveImageConfiguration(with actionProvider: ImageActionProvider) -> UIContextMenuConfiguration {
                    let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                        let saveImage = ContextMenuActionConstants.SaveImage.action(with: actionProvider.saveImage)
                        return UIMenu(title: "", children: [saveImage])
                    }
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
                }
                
                static func CommitCellConfiguration(with actionProvider: CommitCellActionProvider) -> UIContextMenuConfiguration {
                    let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                        var menuChildren: [UIAction] = []
                        let openInSafari = ContextMenuActionConstants.OpenInSafari.action(with: actionProvider.openInSafari)
                        let share = ContextMenuActionConstants.Share.action(with: actionProvider.share)
                        menuChildren.append(openInSafari)
                        menuChildren.append(share)
                        return UIMenu(title: "", children: menuChildren)
                    }
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
                }
                
                static func RepositoryCellConfiguration(with actionProvider: RepositoryCellActionProvider) -> UIContextMenuConfiguration {
                    let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                        var menuChildren: [UIAction] = []
                        if actionProvider.isBookmarked {
                            let unBookmark = ContextMenuActionConstants.UnBookmark.action(with: actionProvider.toggleBookmark)
                            menuChildren.append(unBookmark)
                        } else {
                            let bookmark = ContextMenuActionConstants.Bookmark.action(with: actionProvider.toggleBookmark)
                            menuChildren.append(bookmark)
                        }
                        let openInSafari = ContextMenuActionConstants.OpenInSafari.action(with: actionProvider.openInSafari)
                        let share = ContextMenuActionConstants.Share.action(with: actionProvider.share)
                        menuChildren.append(openInSafari)
                        menuChildren.append(share)
                        return UIMenu(title: "", children: menuChildren)
                    }
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
                }
                
                static func BasicCellConfiguration(with actionProvider: BasicCellActionProvider) -> UIContextMenuConfiguration {
                    let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                        var menuChildren: [UIAction] = []
                        if actionProvider.isBookmarked {
                            let unBookmark = ContextMenuActionConstants.UnBookmark.action(with: actionProvider.toggleBookmark)
                            menuChildren.append(unBookmark)
                        } else {
                            let bookmark = ContextMenuActionConstants.Bookmark.action(with: actionProvider.toggleBookmark)
                            menuChildren.append(bookmark)
                        }
                        let saveImage = ContextMenuActionConstants.SaveImage.action(with: actionProvider.saveImage)
                        let openInSafari = ContextMenuActionConstants.OpenInSafari.action(with: actionProvider.openInSafari)
                        let share = ContextMenuActionConstants.Share.action(with: actionProvider.share)
                        menuChildren.append(saveImage)
                        menuChildren.append(openInSafari)
                        menuChildren.append(share)
                        return UIMenu(title: "", children: menuChildren)
                    }
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
                }
                
                static func SearchHistoryCollectionCellConfiguration(with actionProvider: SearchHistoryCollectionCellActionProvider) -> UIContextMenuConfiguration {
                    let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
                        var menuChildren: [UIAction] = []
                        if actionProvider.isBookmarked {
                            let unBookmark = ContextMenuActionConstants.UnBookmark.action(with: actionProvider.toggleBookmark)
                            menuChildren.append(unBookmark)
                        } else {
                            let bookmark = ContextMenuActionConstants.Bookmark.action(with: actionProvider.toggleBookmark)
                            menuChildren.append(bookmark)
                        }
                        let saveImage = ContextMenuActionConstants.SaveImage.action(with: actionProvider.saveImage)
                        let openInSafari = ContextMenuActionConstants.OpenInSafari.action(with: actionProvider.openInSafari)
                        let share = ContextMenuActionConstants.Share.action(with: actionProvider.share)
                        let delete = ContextMenuActionConstants.Delete.action(with: actionProvider.delete)
                        menuChildren.append(saveImage)
                        menuChildren.append(openInSafari)
                        menuChildren.append(share)
                        menuChildren.append(delete)
                        return UIMenu(title: "", children: menuChildren)
                    }
                    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
                }
                
            }
            
        }
        
        // MARK: - Alert Constants
        
        struct Alert {
            
            struct NoInternet {
                
                static let title = "No Internet".localized()
                
                static func notificationBanner() -> StatusBarNotificationBanner {
                    let banner = StatusBarNotificationBanner(title: title, style: .danger)
                    banner.autoDismiss = false
                    return banner
                }
                
            }
            
            struct InternetError {
                
                static let title = "No Internet".localized()
                static let message = "You're not conntected to the internet, Please connect to Internet and try again later.".localized()
                
                static func alertController() -> UIAlertController {
                    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    controller.addAction(AlertConstants.okAction)
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
                        Task {
                            await MainActor.run {
                                try? BookmarksManager.standard.clearActive()
                                handler()
                            }
                        }
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
                        Task {
                            await MainActor.run { try? DataManager.standard.clearData() }
                        }
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
        
        // MARK: - Error Constants
        
        struct Error {
            
            // Internet error image, title and message
            struct Internet {
                
                static private let image = UIImage(systemName: "wifi.exclamationmark")
                static private let title = "No Internet".localized()
                static private let message = "You're not connected to Internet,\nplease try again later.".localized()
                static let viewModel = ErrorViewModel(image: image, title: title, message: message)

            }
            
            // Network error image, title and message
            struct Network {
                
                static private let image = UIImage(systemName: "exclamationmark.icloud")
                static private let title = "Network Error".localized()
                static private let message = "We're working on it,\nWe will be back soon.".localized()
                static let viewModel = ErrorViewModel(image: image, title: title, message: message)
                
            }
            
            // Data error image, title and message
            struct Data {
                
                static private let image = UIImage(systemName: "externaldrive.badge.xmark")
                static private let title = "Couldn't Retrieve Data".localized()
                static private let message = "We're working on it,\nWe will be back soon.".localized()
                static let viewModel = ErrorViewModel(image: image, title: title, message: message)
                
            }
            
        }
        
        // MARK: - Empty Constants
        
        struct Empty {
            
            // General empty image and title
            struct General {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "WoW, such empty".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Users empty image and title
            struct Users {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "There isn't any users.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Repositories empty image and title
            struct Repositories {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "There isn't any repositories.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Organizations empty image and title
            struct Organizations {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "There isn't any organizations.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Commits empty image and title
            struct Commits {
                
                static private let image = UIImage(systemName: "exclamationmark")
                static private let title = "There isn't any commits.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Search history empty image and title
            struct SearchHistory {
                
                static private let image = UIImage(systemName: "magnifyingglass")
                static private let title = "No Search history found, try searching first.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Search results image and title
            struct SearchResults {
                
                static private let image = UIImage(systemName: "magnifyingglass")
                static private let title = "No Search results found, try searching for a different term.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
            // Bookmarks image and title
            struct Bookmarks {
                
                static private let image = UIImage(systemName: "bookmark.slash")
                static private let title = "No Bookmarks found.".localized()
                static let viewModel = EmptyViewModel(image: image, title: title)
                
            }
            
        }
        
        // MARK: - Label Constants
        
        struct Label {
            
            static let guest = "Signed in as a Guest".localized()
            static let signIn = "Sign in with your Github account to enable extended features.".localized()
            
        }
        
        // MARK: - Button Constants
        
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
        
        // MARK: - Image Constants
        
        struct Image {
            
            static let guest = UIImage(systemName: "person")
            
        }
        
        // MARK: - Table View Constants
        
        struct TableView {
            
            // MARK: - Table View Custom Components Constants
            
            struct CustomComponents {
                
                struct DataSource {
                    
                    static let userDataSource = UserTableViewDataSource()
                    static let repositoryDataSource = RepositoryTableViewDataSource()
                    static let organizationDataSource = OrganizationTableViewDataSource()
                    static let commitDataSource = CommitTableViewDataSource()
                    
                }
                
                struct Delegate {
                    
//                    static let userDelegate = UserTableViewDelegate()
//                    static let repositoryDelegate = RepositoryTableViewDelegate()
//                    static let organizationDelegate = OrganizationTableViewDelegate()
//                    static let commitDelegate = CommitTableViewDelegate()
                    
                }
                
                struct CellConfigurator {
                    
                    static let userCellConfigurator = UserTableViewCellConfigurator()
                    static let repositoryCellConfigurator = RepositoryTableViewCellConfigurator()
                    static let organizationCellConfigurator = OrganizationTableViewCellConfigurator()
                    static let commitCellConfigurator = CommitTableViewCellConfigurator()
                    
                }
                
                struct ContextMenuConfigurator {
                    
//                    static let userContextMenuConfigurator = UserTableViewContextMenuConfigurator()
//                    static let repositoryDelegate = RepositoryTableViewContextMenuConfigurator()
//                    static let organizationDelegate = OrganizationTableViewContextMenuConfigurator()
//                    static let commitDelegate = CommitTableViewContextMenuConfigurator()
                    
                }
                
                struct TapResponder {
                    
//                    static let userTapResponder = UserTableViewTapResponder()
//                    static let repositoryTapResponder = RepositoryTableViewTapResponder()
//                    static let organizationTapResponder = OrganizationTableViewTapResponder()
//                    static let commitTapResponder = CommitTableViewTapResponder()
                    
                }
                
                struct SwipeResponder {
                    
                }
                
            }
            
        }
        
        // MARK: - Collection View Constants
        
        struct CollectionView {
            
            // MARK: - Table View Custom Components Constants
            
            struct CustomComponents {
                
                struct DataSource {
                    
                    static let userDataSource = UserCollectionViewDataSource()
                    static let repositoryDataSource = RepositoryCollectionViewDataSource()
                    static let organizationDataSource = OrganizationCollectionViewDataSource()
                    
                }
                
                struct Delegate {
                    
//                    static let userDelegate = UserCollectionViewDelegate()
//                    static let repositoryDelegate = RepositoryCollectionViewDelegate()
//                    static let organizationDelegate = OrganizationCollectionViewDelegate()
                    
                }
                
                struct CellConfigurator {
                    
                    static let userCellConfigurator = UserCollectionViewCellConfigurator()
                    static let repositoryCellConfigurator = RepositoryCollectionViewCellConfigurator()
                    static let organizationCellConfigurator = OrganizationCollectionViewCellConfigurator()
                    
                }
                
                struct ContextMenuConfigurator {
                    
//                    static let userContextMenuConfigurator = UserCollectionViewContextMenuConfigurator()
//                    static let repositoryDelegate = RepositoryCollectionViewContextMenuConfigurator()
//                    static let organizationDelegate = OrganizationCollectionViewContextMenuConfigurator()
                    
                }
                
                struct TapResponder {
                    
//                    static let userTapResponder = UserCollectionViewTapResponder()
//                    static let repositoryTapResponder = RepositoryCollectionViewTapResponder()
//                    static let organizationTapResponder = OrganizationCollectionViewTapResponder()
                    
                }
                
            }
            
        }
        
    }
    
}
