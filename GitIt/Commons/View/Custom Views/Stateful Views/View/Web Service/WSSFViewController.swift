//
//  WSSFViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/12/2021.
//

import UIKit

class WSSFViewController: UIViewController {

    // MARK: - Properties
    
    var xView: WSSFView! { return view as? WSSFView }
    
    var emptyViewModel: EmptyViewModel = EmptyConstants.General.viewModel
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        if xView == nil {
            // re-initialize table view with SFDynamic table view initializer
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            view = WSSFView(frame: window!.bounds)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        xView.transition(to: .presenting)
    }

    // MARK: - View Helper Methods
    
    func configureView() {
        // Setup  view as super view
        xView.isSuperView = true
        // Setup actions
        xView.errorAction = { [weak self] in self?.load() }
        xView.updateView = { [weak self] in self?.updateView() }
    }
    
    func updateView() { /* Override this method in subclass to provide view updater method */ }

    // MARK: - Load Methods
    
    func load() {
        xView.transition(to: .loading(.initial))
    }
    
    // MARK: - Load Handlers
    
    func loadHandler(error: Error?) {
        if let error = error {
            xView.transition(to: .failed(.initial(error)))
        } else if checkIfEmpty() {
            xView.transition(to: .empty(emptyViewModel))
        } else {
            xView.transition(to: .presenting)
        }
    }
    
    func checkIfEmpty() -> Bool { /* Override this method in subclass to provide empty checking method */
        return false
    }

}
