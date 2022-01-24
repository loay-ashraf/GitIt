//
//  UIKitExtensions.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

extension UIApplication {

    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let searchController = controller as? UISearchController {
            if let resultsController = searchController.searchResultsController {
                return topViewController(controller: resultsController)
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

extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
    
}

extension UIColor {

    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }

    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255.0
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255.0
                    b = CGFloat((hexNumber & 0x0000ff)) / 255.0
                    a = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
    
}

/*extension UITableView {

    var registeredNibs: [String: UINib] {
        let dict = value(forKey: "_nibMap") as? [String: UINib]
        return dict ?? [:]
    }

    var registeredCells: [String: Any] {
        let dict = value(forKey: "_cellClassDict") as? [String: Any]
        return dict ?? [:]
    }
    
}*/

extension UIView {
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    var cornerCurve: CALayerCornerCurve {
        get { return layer.cornerCurve }
        set { layer.cornerCurve = newValue }
    }
    
    var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
}
