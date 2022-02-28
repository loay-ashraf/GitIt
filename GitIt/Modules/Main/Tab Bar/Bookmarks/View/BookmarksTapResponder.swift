//
//  BookmarksTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import UIKit

class UserBookmarksTapResponder: TableViewTapResponder {
    
    override func respondToTap(atRow row: Int) {
        if let viewController = viewController as? UserBookmarksViewController {
            viewController.showDetail(atRow: row)
        }
    }
    
}

class RepositoryBookmarksTapResponder: TableViewTapResponder {
    
    override func respondToTap(atRow row: Int) {
        if let viewController = viewController as? RepositoryBookmarksViewController {
            viewController.showDetail(atRow: row)
        }
    }
    
}

class OrganizationBookmarksTapResponder: TableViewTapResponder {
    
    override func respondToTap(atRow row: Int) {
        if let viewController = viewController as? OrganizationBookmarksViewController {
            viewController.showDetail(atRow: row)
        }
    }
    
}
