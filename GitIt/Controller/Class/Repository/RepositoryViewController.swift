//
//  RepositoryViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class RepositoryViewController: UITableViewController {

    let logicController: RepositoryLogicController
    var searchCoordinator: SearchCoordinator<RepositoryModel>!
    var loadingSpinner: Spinner!
    var context: RepositoryContext {
        return logicController.context
    }
    
    // MARK: - Initialisation
    
    init(context: RepositoryContext, contextParameters: Any? = nil) {
        logicController = RepositoryLogicController(context: context, contextParameters: contextParameters)
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

extension RepositoryViewController {
    
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
        title = context.titleValue
        navigationItem.largeTitleDisplayMode = context == .main ? .always : .never
        
        configureTableView()
        
        loadingSpinner = Spinner(self)
        
        searchCoordinator = context == .main ? SearchCoordinator(self) : nil
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
