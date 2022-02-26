//
//  RepositoryViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class RepositoryViewController: WSSFDynamicTableViewController<RepositoryViewModel>, StoryboardableViewController {
    
    // MARK: - Properties
    
    static var storyboardIdentifier = "RepositoryVC"
    
    private var context: RepositoryContext
    
    private var searchCoordinator: SearchCoordinator<RepositorySearchModule>!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, context: RepositoryContext) {
        self.context = context
        super.init(coder: coder)
        tableViewDataSource = RepositoryTableViewDataSource()
        tableViewDelegate = RepositoryTableViewDelegate(self)
        viewModel = RepositoryViewModel(context: context)
        emptyViewModel = EmptyConstants.Repositories.viewModel
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }
    
    static func instatiate<T: ViewControllerContext>(context: T) -> UIViewController {
        if let repositoryContext = context as? RepositoryContext {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> RepositoryViewController in
                        self.init(coder: coder, context: repositoryContext)!
            })
        } else {
            return UIViewController()
        }
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
        
        title = context.title
        switch context {
        case .main, .trending: navigationItem.largeTitleDisplayMode = .always
        default: navigationItem.largeTitleDisplayMode = .never
        }
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        switch context {
        case .main: searchCoordinator = SearchCoordinator(self)
        default: searchCoordinator = nil
        }
    }
    
    // MARK: - View Actions
    
    func showDetail(atRow row: Int) {
        let cellViewModelItem = viewModel.items[row]
        let detailVC = RepositoryDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
        NavigationRouter.push(viewController: detailVC)
    }
    
    func toggleBookmark(atRow row: Int) {
        viewModel.toggleBookmark(atRow: row)
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
