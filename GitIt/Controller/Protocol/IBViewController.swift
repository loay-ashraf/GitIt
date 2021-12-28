//
//  IBViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import Foundation
import UIKit

protocol IBViewController: UIViewController {
    
    static var storyboardIdentifier: String { get }
    static func instatiateFromStoryboard(with parameters: Any) -> UIViewController
    static func instatiateFromStoryboard<Type: Model>(with model: Type) -> UIViewController
    
}
