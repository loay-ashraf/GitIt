//
//  CommitViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitViewController: UITableViewController {

    let logicController: CommitLogicController
    var loadingSpinner: Spinner!
    
    // MARK: - Initialisation
    
    init(parameters: String) {
        logicController = CommitLogicController(parameters: parameters)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated from storyboard.")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        render(.loading)
        logicController.load(then: render(_:))
    }

}

extension CommitViewController {
    
    // MARK: - UI Helper Methods
    
    func render(_ state: ViewState) {
        switch state {
        case .loading, .paginating: showSpinner(viewState: state)
        case .presenting: hideSpinner()
                          updateUI()
        case .failed(let error): print(error)
        }
    }
    
    private func updateUI() {
        tableView.reloadData()
    }
    
    func configureUI() {
        title = "Commits"
        navigationItem.largeTitleDisplayMode = .never
        
        configureTableView()
        
        loadingSpinner = Spinner(self)
    }
    
    func showSpinner(viewState: ViewState) {
        switch viewState {
            case .loading: loadingSpinner.showMainSpinner()
            case .paginating: loadingSpinner.showFooterSpinner()
            default: return
        }
    }
    
    func hideSpinner() {
        loadingSpinner.hideMainSpinner()
        loadingSpinner.hideFooterSpinner()
        tableView.refreshControl?.endRefreshing()
    }

}
