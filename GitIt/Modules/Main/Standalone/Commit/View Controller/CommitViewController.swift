//
//  CommitViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitViewController: WSSFDynamicTableViewController<CommitViewModel>, StoryboardableViewController {
    
    // MARK: - Properties
    
    static var storyboardIdentifier = "CommitVC"
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, repositoryFullName: String) {
        super.init(coder: coder)
        tableViewDataSource = CommitTableViewDataSource()
        tableViewDelegate = CommitTableViewDelegate(self)
        viewModel = CommitViewModel(repositoryFullName: repositoryFullName)
        emptyViewModel = EmptyConstants.Commits.viewModel
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }

    static func instatiate(parameter: String) -> UIViewController {
        let storyBoard = StoryboardConstants.main
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> CommitViewController in
                    self.init(coder: coder, repositoryFullName: parameter)!
                })
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }

    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        load(with: .initial)
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        
        title = "Commits".localized()
        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
    }
    
    // MARK: - View Actions
    
    func showDetail(atRow row: Int) {
        let cellViewModelItem = viewModel.items[row]
        let detailVC = CommitDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
        NavigationRouter.push(viewController: detailVC)
    }
    
    func openInSafari(atRow row: Int) {
        let cellViewModelItem = viewModel.items[row]
        URLHelper.openWebsite(cellViewModelItem.htmlURL)
    }
    
    func share(atRow row: Int) {
        let cellViewModelItem = viewModel.items[row]
        URLHelper.shareWebsite(cellViewModelItem.htmlURL)
    }
    
    // MARK: - Loading Methods
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        if loadingViewState == .initial, didLoadInitial { return }
        else { didLoadInitial = true }
        Task {
            switch loadingViewState {
            case .initial: loadHandler(error: await viewModel?.load())
            case .refresh: refreshHandler(error: await viewModel?.refresh())
            case .paginate: paginateHandler(error: await viewModel?.paginate())
            }
        }
    }
    
    // MARK: - Bind to View Model Method
    
    func bindToViewModel() {
        viewModel.bind { [weak self] cellViewModelList in
            if let cellViewModelList = cellViewModelList {
                self?.tableViewDataSource.cellViewModels = cellViewModelList.items
            }
        }
    }

}
