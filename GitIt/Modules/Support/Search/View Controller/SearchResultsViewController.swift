//
//  SearchResultsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class SearchResultsViewController<Type: Model>: SFDynamicTableViewController<Type> {
    
    override var model: List<Type>! { return logicController.model }
    override var emptyViewModel: EmptyViewModel { return EmptyConstants.searchResults.viewModel }
    
    private weak var delegate: ResultsDelegate!
    private var logicController: SearchResultsLogicController<Type>!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, delegate: ResultsDelegate) {
        super.init(coder: coder, tableViewDataSource: SearchResultsDataSource<Type>.raw(), tableViewDelegate: SearchResultsDelegate<Type>(delegate: delegate))
        self.delegate = delegate
        logicController = SearchResultsLogicController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func instatiateFromStoryboard(with delegate: ResultsDelegate) -> SearchResultsViewController<Type> {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        return storyBoard.instantiateViewController(identifier: "ResultsVC", creator: {coder -> SearchResultsViewController<Type> in
                        self.init(coder: coder, delegate: delegate)!
                })
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }
    
    // MARK: - Loading Methods
    
    func loadResults(with keyword: String) {
        reset()
        logicController.keyword = keyword
        load(with: .initial)
    }
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: logicController.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: logicController.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: logicController.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }
    
    // MARK: - Reset Methods
    
    override func reset() {
        logicController.reset()
        updateView()
    }

}
