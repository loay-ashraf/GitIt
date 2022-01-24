//
//  CollectionViewTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CollectionViewTapResponder {
    
    var viewControllerClass: IBViewController.Type!
    var customResponse: ((Any) -> Void)!
    
    init(viewControllerClass: IBViewController.Type? = nil, customResponse: ((Any) -> Void)? = nil) {
        self.viewControllerClass = viewControllerClass
        self.customResponse = customResponse
    }

    func respondToTap<Type>(with item: Type) {
        if let customRespone = customResponse {
            customRespone(item)
        } else if let viewControllerClass = viewControllerClass {
            let detailVC = viewControllerClass.instatiateWithModel(with: item)
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