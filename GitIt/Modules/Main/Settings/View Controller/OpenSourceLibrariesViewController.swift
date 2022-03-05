//
//  OpenSourceLibrariesViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/02/2022.
//

import UIKit

class OpenSourceLibrariesViewController: UITableViewController, StoryboardableViewController {
    
    // MARK: - Properties
    
    static var storyboardIdentifier = "OpenSourceLibrariesVC"
    
    // MARK: - Initialization
    
    static func instatiate() -> UIViewController {
        let storyBoard = StoryboardConstants.main
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> OpenSourceLibrariesViewController in
                self.init(coder: coder)!
        })
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: let detailVC = RepositoryDetailViewController.instatiate(parameter: "Alamofire/Alamofire")
                NavigationRouter.push(viewController: detailVC)
        case 1: let detailVC = RepositoryDetailViewController.instatiate(parameter: "onevcat/Kingfisher")
                NavigationRouter.push(viewController: detailVC)
        case 2: let detailVC = RepositoryDetailViewController.instatiate(parameter: "realm/realm-swift")
                NavigationRouter.push(viewController: detailVC)
        case 3: let detailVC = RepositoryDetailViewController.instatiate(parameter: "futuretap/InAppSettingsKit")
                NavigationRouter.push(viewController: detailVC)
        case 4: let detailVC = RepositoryDetailViewController.instatiate(parameter: "hackiftekhar/IQKeyboardManager")
                NavigationRouter.push(viewController: detailVC)
        case 5: let detailVC = RepositoryDetailViewController.instatiate(parameter: "SVProgressHUD/SVProgressHUD")
                NavigationRouter.push(viewController: detailVC)
        case 6: let detailVC = RepositoryDetailViewController.instatiate(parameter: "Juanpe/SkeletonView")
                NavigationRouter.push(viewController: detailVC)
        case 7: let detailVC = RepositoryDetailViewController.instatiate(parameter: "Daltron/NotificationBanner")
                NavigationRouter.push(viewController: detailVC)
        case 8: let detailVC = RepositoryDetailViewController.instatiate(parameter: "keitaoouchi/MarkdownView")
                NavigationRouter.push(viewController: detailVC)
        default: break
        }
    }
    
}
