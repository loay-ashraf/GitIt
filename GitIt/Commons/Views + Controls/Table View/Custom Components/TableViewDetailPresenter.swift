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
