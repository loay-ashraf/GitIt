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
    static func instatiate<T: CellViewModel>(cellViewModel: T) -> UIViewController
    static func instatiate<T: Model>(model: T) -> UIViewController
    
}
