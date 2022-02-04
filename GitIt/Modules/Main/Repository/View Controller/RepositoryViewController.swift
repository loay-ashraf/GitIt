//
//  RepositoryViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class RepositoryViewController: SFDynamicTableViewController<RepositoryCellViewModel>, StoryboardableViewController {
    
    // MARK: - Properties
    
    static var storyboardIdentifier = "RepositoryVC"
    
    private var context: RepositoryContext
    
    private var searchCoordinator: SearchCoordinator<RepositoryModel>!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, context: RepositoryContext) {
        self.context = context
        super.init(coder: coder, tableViewDataSource: yz(), tableViewDelegate: xz())
        viewModel = RepositoryViewModel(context: context)
        emptyViewModel = ViewConstants.Empty.Repositories.viewModel
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
    
    static func instatiate(parameter: String) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using context")
    }
    
    static func instatiate<T: CellViewModel>(cellViewModel: T) -> UIViewController  {
        fatalError("Fatal Error, This View controller is instaniated only using context")
    }
    
    static func instatiate<T: Model>(model: T) -> UIViewController  {
        fatalError("Fatal Error, This View controller is instaniated only using context")
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load(with: .initial)
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        
        title = context.title
        switch context {
        case .main: navigationItem.largeTitleDisplayMode = .always
        default: navigationItem.largeTitleDisplayMode = .never
        }
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
//        switch context {
//        case .main: searchCoordinator = SearchCoordinator(self)
//        default: searchCoordinator = nil
//        }
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
