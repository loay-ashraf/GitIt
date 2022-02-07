//
//  SearchResultsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit
import Kingfisher
import SVProgressHUD

class SearchResultsViewController<T: SearchResultsViewModel>: SFDynamicTableViewController<T> {
    
    // MARK: - Properties
    
    private weak var delegate: SearchResultsDelegate!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, delegate: SearchResultsDelegate) {
        super.init(coder: coder)
        self.delegate = delegate
        tableViewDataSource = SearchResultsTableViewDataSource<T>()
        tableViewDelegate = SearchResultsTableViewDelegate<T>(self)
        viewModel = T()
        emptyViewModel = EmptyConstants.SearchResults.viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func instatiateFromStoryboard(with delegate: SearchResultsDelegate) -> SearchResultsViewController<T> {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        return storyBoard.instantiateViewController(identifier: "ResultsVC", creator: {coder -> SearchResultsViewController<T> in
                        self.init(coder: coder, delegate: delegate)!
                })
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }
    
    // MARK: - View Actions
    
    func showDetail(atRow row: Int) {
        if let cellViewModelItem = viewModel.items[row] as? UserTableCellViewModel {
            delegate.dismissResultsKeyboard()
            delegate.addObject(with: cellViewModelItem)
            let detailVC = UserDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
            NavigationRouter.push(viewController: detailVC)
        } else if let cellViewModelItem = viewModel.items[row] as? RepositoryTableCellViewModel {
            delegate.dismissResultsKeyboard()
            delegate.addObject(with: cellViewModelItem)
            let detailVC = RepositoryDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
            NavigationRouter.push(viewController: detailVC)
        } else if let cellViewModelItem = viewModel.items[row] as? OrganizationTableCellViewModel {
            delegate.dismissResultsKeyboard()
            delegate.addObject(with: cellViewModelItem)
            let detailVC = OrganizationDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
            NavigationRouter.push(viewController: detailVC)
        }
    }
    
    func toggleBookmark(atRow row: Int) {
        viewModel.toggleBookmark(atRow: row)
    }
    
    func saveImage(atRow row: Int) {
        if let cellViewModelItem = viewModel.items[row] as? UserTableCellViewModel {
            KingfisherManager.shared.retrieveImage(with: cellViewModelItem.avatarURL) { result in
                if let retreiveResult = try? result.get() {
                    UIImageWriteToSavedPhotosAlbum(retreiveResult.image, self, nil, nil)
                    SVProgressHUD.showSuccess(withStatus: "Image Saved".localized())
                }
            }
        } else if let cellViewModelItem = viewModel.items[row] as? OrganizationTableCellViewModel {
            KingfisherManager.shared.retrieveImage(with: cellViewModelItem.avatarURL) { result in
                if let retreiveResult = try? result.get() {
                    UIImageWriteToSavedPhotosAlbum(retreiveResult.image, self, nil, nil)
                    SVProgressHUD.showSuccess(withStatus: "Image Saved".localized())
                }
            }
        }
    }
    
    func openInSafari(atRow row: Int) {
        if let cellViewModelItem = viewModel.items[row] as? UserTableCellViewModel {
            URLHelper.openWebsite(cellViewModelItem.htmlURL)
        } else if let cellViewModelItem = viewModel.items[row] as? RepositoryTableCellViewModel {
            URLHelper.openWebsite(cellViewModelItem.htmlURL)
        } else if let cellViewModelItem = viewModel.items[row] as? OrganizationTableCellViewModel {
            URLHelper.openWebsite(cellViewModelItem.htmlURL)
        }
    }
    
    func share(atRow row: Int) {
        if let cellViewModelItem = viewModel.items[row] as? UserTableCellViewModel {
            URLHelper.shareWebsite(cellViewModelItem.htmlURL)
        } else if let cellViewModelItem = viewModel.items[row] as? RepositoryTableCellViewModel {
            URLHelper.shareWebsite(cellViewModelItem.htmlURL)
        } else if let cellViewModelItem = viewModel.items[row] as? OrganizationTableCellViewModel {
            URLHelper.shareWebsite(cellViewModelItem.htmlURL)
        }
    }
    
    // MARK: - Loading Methods
    
    func loadResults(with keyword: String) {
        reset()
        viewModel.setQuery(query: keyword)
        load(with: .initial)
    }
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: viewModel.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: viewModel.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: viewModel.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }
    
    // MARK: - Reset Methods
    
    override func reset() {
        viewModel.reset()
        updateView()
    }

}
