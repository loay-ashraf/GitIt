//
//  Spinner.swift
//  GitIt
//
//  Created by Loay Ashraf on 12/11/2021.
//

import Foundation
import UIKit

class Spinner: UIViewController {
    
    private weak var rootViewController: UIViewController!
    private weak var rootView: UIView? { return rootViewController.view }
    private var mainView = UIView()
    private var footerView = UIView()
    private var mainSpinner = UIActivityIndicatorView()
    private var footerSpinner = UIActivityIndicatorView()
    var isActive = false
    
    // MARK: - Initialisation
    
    init(_ rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        view.frame = rootView!.frame
        view.isOpaque = true
        view.backgroundColor = .systemBackground
        view.isUserInteractionEnabled = false
        view.addSubview(mainView)
        view.addSubview(mainSpinner)
        
        mainView.layer.cornerRadius = 10.0
        mainView.layer.cornerCurve = .continuous
        mainView.backgroundColor = .black.withAlphaComponent(0.7)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        mainSpinner.color = .white
        mainSpinner.style = .large
        mainSpinner.translatesAutoresizingMaskIntoConstraints = false
        mainSpinner.startAnimating()
        
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainView.heightAnchor.constraint(equalTo: mainSpinner.heightAnchor, constant: 40.0),
            mainView.widthAnchor.constraint(equalTo: mainSpinner.widthAnchor, constant: 40.0),
            mainSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Main Spinner Methods
    
    func showMainSpinner() {
        rootViewController.addChild(self)
        rootViewController.view.addSubview(view)
        didMove(toParent: rootViewController)
        isActive = true
    }
    
    func hideMainSpinner() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
        isActive = false
    }
    
    // MARK: - Footer Spinner Methods
    
    func showFooterSpinner() {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width , height: 80))
        footerSpinner = UIActivityIndicatorView()
        footerSpinner.center = footerView.center
        footerSpinner.startAnimating()
        footerView.addSubview(footerSpinner)
        (rootViewController as! UITableViewController).tableView.tableFooterView = footerView
        isActive = true
    }
    
    func hideFooterSpinner() {
        if (rootViewController as! UITableViewController).tableView.tableFooterView == footerView {
            (rootViewController as! UITableViewController).tableView.tableFooterView = UIView()
            isActive = false
        }
    }

}
