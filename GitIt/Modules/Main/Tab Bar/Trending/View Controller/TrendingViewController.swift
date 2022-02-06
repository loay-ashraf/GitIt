//
//  TrendingViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 26/01/2022.
//

import UIKit

class TrendingViewController: SFDynamicTableViewController<RepositoryViewModel> {

    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, tableViewDataSource: RepositoryTableViewDataSource(), tableViewDelegate: RepositoryTableViewDelegate())
        viewModel = RepositoryViewModel(context: .trending)
        emptyViewModel = Constants.View.Empty.Repositories.viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load(with: .initial)
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        xTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        NavigayionBarConstants.configureAppearance(for: navigationController?.navigationBar)
    }
    
    // MARK: - Loading Methods
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: viewModel.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: viewModel.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: viewModel.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }

}
