//
//  TableViewDetailPresenter.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewDetailPresenter {
    
    var viewControllerClass: IBViewController.Type!
    
    func presentViewController<Type>(with item: Type) {
        let detailVC = viewControllerClass.instatiateWithModel(with: item)
        if let topViewController = UIApplication.topViewController() {
            topViewController.present(detailVC, animated: true, completion: nil)
        }
    }
    
    func pushViewController<Type>(with item: Type) {
        let detailVC = viewControllerClass.instatiateWithModel(with: item)
        if let topViewController = UIApplication.topViewController(), let navigationController = topViewController.navigationController {
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    
}

class UserDetailViewControllerPresenter: TableViewDetailPresenter {
    
    override init() {
        super.init()
        viewControllerClass = UserDetailViewController.self
    }
    
}

class RepositoryDetailViewControllerPresenter: TableViewDetailPresenter {
    
    override init() {
        super.init()
        viewControllerClass = RepositoryDetailViewController.self
    }
    
}

class OrganizationDetailViewControllerPresenter: TableViewDetailPresenter {
    
    override init() {
        super.init()
        viewControllerClass = OrganizationDetailViewController.self
    }
    
}

class CommitDetailViewControllerPresenter: TableViewDetailPresenter {
    
    override init() {
        super.init()
        viewControllerClass = CommitDetailViewController.self
    }
    
}

extension UIApplication {

    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        if let alert = controller as? UIAlertController {
            if let navigationController = alert.presentingViewController as? UINavigationController {
                return navigationController.viewControllers.last
            }
            return alert.presentingViewController
        }
        return controller
    }

}
