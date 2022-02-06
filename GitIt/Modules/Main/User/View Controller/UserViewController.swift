//
//  UserViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 08/11/2021.
//

import UIKit

class UserViewController: SFDynamicTableViewController<UserViewModel>, StoryboardableViewController {

    // MARK: - Properties
    
    static var storyboardIdentifier = "UserVC"
    
    private var context: UserContext
    
    private var searchCoordinator: SearchCoordinator<UserSearchModule>!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, context: UserContext) {
        self.context = context
        super.init(coder: coder, tableViewDataSource: UserTableViewDataSource(), tableViewDelegate: UserTableViewDelegate())
        viewModel = UserViewModel(context: context)
        emptyViewModel = ViewConstants.Empty.Users.viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }
    
    static func instatiate<T: ViewControllerContext>(context: T) -> UIViewController {
        if let userContext = context as? UserContext {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserViewController in
                        self.init(coder: coder, context: userContext)!
            })
        } else {
            return UIViewController()
        }
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
        
        switch context {
        case .main: searchCoordinator = SearchCoordinator(self)
        default: searchCoordinator = nil
        }
    }
    
    // MARK: - Loading Methods
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: viewModel?.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: viewModel?.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: viewModel?.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }
    
}
