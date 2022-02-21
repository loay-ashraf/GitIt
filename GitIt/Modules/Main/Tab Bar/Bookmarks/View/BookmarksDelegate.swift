//
//  BookmarksDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import UIKit

class UserBookmarksDelegate: TableViewDelegate {
    
    init(_ viewController: UIViewController) {
        super.init()
        tapResponder = UserBookmarksTapResponder(viewController)
        contextMenuConfigurator = UserBookmarksContextMenuConfigurator(viewController)
    }
    
}

class RepositoryBookmarksDelegate: TableViewDelegate {
    
    init(_ viewController: UIViewController) {
        super.init()
        tapResponder = RepositoryBookmarksTapResponder(viewController)
        contextMenuConfigurator = RepositoryBookmarksContextMenuConfigurator(viewController)
    }
    
}

class OrganizationBookmarksDelegate: TableViewDelegate {
    
    init(_ viewController: UIViewController) {
        super.init()
        tapResponder = OrganizationBookmarksTapResponder(viewController)
        contextMenuConfigurator = OrganizationBookmarksContextMenuConfigurator(viewController)
    }
    
}
