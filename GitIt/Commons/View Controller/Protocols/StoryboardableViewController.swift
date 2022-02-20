//
//  StoryboardableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import Foundation
import UIKit

protocol StoryboardableViewController: UIViewController {
    
    static var storyboardIdentifier: String { get }
    static func instatiate<T: ViewControllerContext>(context: T) -> UIViewController
    static func instatiate(parameter: String) -> UIViewController
    static func instatiate(parameters: [String]) -> UIViewController
    static func instatiate<T: CollectionCellViewModel>(collectionCellViewModel: T) -> UIViewController
    static func instatiate<T: TableCellViewModel>(tableCellViewModel: T) -> UIViewController
    static func instatiate<T: Model>(model: T) -> UIViewController
    
}

extension StoryboardableViewController {
    
    static func instatiate<T: ViewControllerContext>(context: T) -> UIViewController {
        fatalError("Fatal Error, This View controller cannot be instaniated using context")
    }
    
    static func instatiate(parameter: String) -> UIViewController {
        fatalError("Fatal Error, This View controller cannot be instaniated using parameter")
    }
    
    static func instatiate(parameters: [String]) -> UIViewController {
        fatalError("Fatal Error, This View controller cannot be instaniated using parameters")
    }
    
    static func instatiate<T: CollectionCellViewModel>(collectionCellViewModel: T) -> UIViewController {
        fatalError("Fatal Error, This View controller cannot be instaniated using Collection Cell View Model")
    }
    
    static func instatiate<T: TableCellViewModel>(tableCellViewModel: T) -> UIViewController {
        fatalError("Fatal Error, This View controller cannot be instaniated using Table Cell View Model")
    }
    
    static func instatiate<T: Model>(model: T) -> UIViewController {
        fatalError("Fatal Error, This View controller cannot be instaniated using Model")
    }
    
}
