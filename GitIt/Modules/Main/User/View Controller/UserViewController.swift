//
//  UserViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 08/11/2021.
//

import UIKit

class UserViewController: SFDynamicTableViewController<UserModel>, IBViewController {
    
    static var storyboardIdentifier = "UserVC"
    
    override var model: List<UserModel>! { return logicController.model }
    override var emptyViewModel: EmptyViewModel { return Constants.View.Empty.Users.viewModel }
    
    private var context: UserContext
    private let logicController: UserLogicController
    
    private var searchCoordinator: SearchCoordinator<UserModel>!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, context: UserContext) {
        self.context = context
        logicController = context.logicController
        super.init(coder: coder, tableViewDataSource: UserTableViewDataSource(), tableViewDelegate: UserTableViewDelegate())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }
    
    static func instatiateWithContext(with context: UserContext) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserViewController in
                    self.init(coder: coder, context: context)!
                })
    }
    
    static func instatiateWithParameters(with parameters: Any) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using context and context parameters")
    }
    
    static func instatiateWithModel(with model: Any) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using context and context parameters")
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
        case .initial: logicController.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: logicController.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: logicController.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }
    
}
