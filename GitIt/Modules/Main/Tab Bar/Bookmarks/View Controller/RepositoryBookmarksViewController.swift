//
//  RepositoryBookmarksViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import UIKit

class RepositoryBookmarksViewController: DPSFDynamicTableViewController<RepositoryBookmarksViewModel> {
    
    // MARK: - Properties
    
    var isEmpty = Observable<Bool>()

    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableViewDataSource = RepositoryTableViewDataSource()
        tableViewDelegate = RepositoryBookmarksDelegate(self)
        viewModel = RepositoryBookmarksViewModel()
        emptyViewModel = EmptyConstants.Bookmarks.viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    // MARK: - View Actions
    
    func clear() {
        viewModel.clear()
    }
    
    func showDetail(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModelArray[row]
        let detailVC = RepositoryDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
        NavigationRouter.push(viewController: detailVC)
    }
    
    func toggleBookmark(atRow row: Int) {
        viewModel.toggleBookmark(atRow: row)
    }
    
    func openInSafari(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModelArray[row]
        URLHelper.openWebsite(cellViewModelItem.htmlURL)
    }
    
    func share(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModelArray[row]
        URLHelper.shareWebsite(cellViewModelItem.htmlURL)
    }
    
    // MARK: - Bind to View Model Method
    
    func bindToViewModel() {
        viewModel.bind { [weak self] repositoryBookmarks in
            if let repositoryBookmarks = repositoryBookmarks {
                self?.tableViewDataSource.cellViewModels = repositoryBookmarks
                DispatchQueue.main.async {
                    if repositoryBookmarks.isEmpty {
                        self?.xTableView.transition(to: .empty(self!.emptyViewModel))
                    } else {
                        self?.xTableView.transition(to: .presenting)
                    }
                }
                self?.isEmpty.value = self?.viewModel.isEmpty
            }
        }
    }
    
}
