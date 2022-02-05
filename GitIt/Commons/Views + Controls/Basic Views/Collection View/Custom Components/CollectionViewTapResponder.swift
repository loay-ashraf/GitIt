//
//  CollectionViewTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CollectionViewTapResponder {
    
    var viewControllerClass: StoryboardableViewController.Type!
    var customResponse: ((Any) -> Void)!
    
    init(viewControllerClass: StoryboardableViewController.Type? = nil, customResponse: ((Any) -> Void)? = nil) {
        self.viewControllerClass = viewControllerClass
        self.customResponse = customResponse
    }

    func respondToTap<T: CollectionCellViewModel>(with item: T) {
        if let customRespone = customResponse {
            customRespone(item)
        } else if let viewControllerClass = viewControllerClass {
            let detailVC = viewControllerClass.instatiate(collectionCellViewModel: item)
            if let topViewController = UIApplication.topViewController() {
                if let navigationController = topViewController.navigationController {
                    navigationController.pushViewController(detailVC, animated: true)
                } else {
                    topViewController.present(detailVC, animated: true, completion: nil)
                }
            }
        }
    }
    
}
