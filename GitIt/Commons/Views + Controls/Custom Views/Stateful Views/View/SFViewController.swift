//
//  SFViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/12/2021.
//

import UIKit

class SFViewController: UIViewController {

    var xView: SFView! { return view as? SFView }
    
    private(set) var emptyViewModel: EmptyViewModel = EmptyConstants.General.viewModel
    
    // MARK: - Initialisation
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        if xView == nil {
            // re-initialize table view with SFDynamic table view initializer
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            view = SFView(frame: window!.bounds)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - View Helper Methods
    
    func configureView() {
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
