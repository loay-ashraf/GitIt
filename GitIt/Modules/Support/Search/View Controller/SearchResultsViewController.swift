//
//  SearchResultsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class SearchResultsViewController<T: SearchResultsViewModel>: SFDynamicTableViewController<T> {
    
    // MARK: - Properties
    
    private weak var delegate: SearchResultsDelegate!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, delegate: SearchResultsDelegate) {
        super.init(coder: coder, tableViewDataSource: SearchResultsTableViewDataSource<T.TableCellViewModelType>.raw(), tableViewDelegate: SearchResultsTableViewDelegate<T.TableCellViewModelType>(delegate: delegate))
        self.delegate = delegate
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
