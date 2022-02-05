//
//  BookmarksViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class BookmarksViewController: UIViewController {
    
    var userModel: List<UserModel> { return List<UserModel>(with: logicController.userModel) }
    var repositoryModel: List<RepositoryModel> { return List<RepositoryModel>(with: logicController.repositoryModel) }
    var organizationModel: List<OrganizationModel> { return List<OrganizationModel>(with: logicController.organizationModel) }
    
    var logicController: BookmarksLogicController!
    var context: BookmarksContext! {
        get { return logicController.bookmarksContext }
        set { logicController.bookmarksContext = newValue }
    }
    
    // MARK: - Table View Data Sources
    
    var userDataSource: TableViewDataSource<UserTableCellViewModel> = TableViewDataSourceConstants.userDataSource
    var repositoryDataSource: TableViewDataSource<RepositoryTableCellViewModel> = TableViewDataSourceConstants.repositoryDataSource
    var organizationDataSource: TableViewDataSource<OrganizationTableCellViewModel> = TableViewDataSourceConstants.organizationDataSource
    
    // MARK: - Table View Delegates
    
    var userDelegate: TableViewDelegate<UserTableCellViewModel> = TableViewDelegateConstants.userDelegate
    var repositoryDelegate: TableViewDelegate<RepositoryTableCellViewModel> = TableViewDelegateConstants.repositoryDelegate
    var organizationDelegate: TableViewDelegate<OrganizationTableCellViewModel> = TableViewDelegateConstants.organizationDelegate
    
    // MARK: - View Outlets
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: SFDynamicTableView!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        logicController = BookmarksLogicController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigayionBarConstants.configureAppearance(for: navigationController?.navigationBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        load()
    }
    
    // MARK: - View Helper Methods
    
    func configureView() {
        configureCurrentContext()
    }
    
    func updateView() {
        tableView.reloadData()
    }
    
    // MARK: - View Synchronization Methods
    
    func synchronizeTableView() {
//        switch context {
//        case .users: userDataSource.model = userModel
//                     userDelegate.model = userModel
//        case .repositories: repositoryDataSource.model = repositoryModel
//                            repositoryDelegate.model = repositoryModel
//        case .organizations: organizationDataSource.model = organizationModel
//                             organizationDelegate.model = organizationModel
//        default: break
//        }
    }
    
    // MARK: - View Actions
    
    @IBAction func selectorChanged(_ sender: Any) {
        configureView()
        load()
    }
    
    @IBAction func clearBookmarks(_ sender: UIBarButtonItem) {
        AlertHelper.showAlert(alert: .clearBookmarks({ [weak self] in
            self?.logicController.clear()
            self?.loadHandler(error: nil)
        }))
    }
    
    // MARK: - Load Methods
    
    func load() {
        tableView.transition(to: .loading(.initial))
        logicController.load { [weak self] error in self?.loadHandler(error: error) }
    }
    
    // MARK: - Load Handler Methods
    
    func loadHandler(error: Error?) {
        if let error = error {
            tableView.transition(to: .failed(.initial(error)))
        } else if checkIfEmpty() {
            tableView.transition(to: .empty(EmptyConstants.Bookmarks.viewModel))
            clearButton.isEnabled = false
        } else {
            synchronizeTableView()
            tableView.transition(to: .presenting)
            clearButton.isEnabled = true
        }
    }
    
    func checkIfEmpty() -> Bool {
        switch context {
        case .users: return userModel.isEmpty
        case .repositories: return repositoryModel.isEmpty
        case .organizations: return organizationModel.isEmpty
        default: return true
        }
    }
    
    // MARK: - Bookmarks Context Methods
    
    func configureCurrentContext() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: switchContext(to: .users)
        case 1: switchContext(to: .repositories)
        case 2: switchContext(to: .organizations)
        default: break
        }
    }
    
    func switchContext(to context: BookmarksContext) {
        logicController.bookmarksContext = context
        switch context {
        case .users: tableView.setDataSource(userDataSource)
                     tableView.setDelegate(userDelegate)
        case .repositories: tableView.setDataSource(repositoryDataSource)
                            tableView.setDelegate(repositoryDelegate)
        case .organizations: tableView.setDataSource(organizationDataSource)
                             tableView.setDelegate(organizationDelegate)
        default: break
        }
    }

}
