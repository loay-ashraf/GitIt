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
    
    private let logicController: UserLogicController
    private var context: UserContext { return logicController.context }
    
    private var searchCoordinator: SearchCoordinator<UserModel>!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, context: UserContext, contextParameters: Any? = nil) {
        logicController = UserLogicController(context: context, contextParameters: contextParameters)
        super.init(coder: coder, cellType: UserTableViewCell.self, detailViewControllerType: UserDetailViewController.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }
    
    static func instatiateWithContextAndParameters(with context: UserContext, with contextParameters: Any? = nil) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserViewController in
                    self.init(coder: coder, context: context, contextParameters: contextParameters)!
                })
    }
    
    static func instatiateWithParameters(with parameters: Any) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using context and context parameters")
    }
    
    static func instatiateWithModel(with model: Any) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using context and context parameters")
    }
    
    deinit {
        print("Controller deallocated")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load(with: .initial)
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        
        title = context.titleValue
        navigationItem.largeTitleDisplayMode = context == .main ? .always : .never
        
        if subViewsOffsetSize != .searchScreen {
            if context != .main {
                subViewsOffsetSize = .subScreen
            } else {
                subViewsOffsetSize = .mainScreenWithSearch
            }
        }
        
        searchCoordinator = context == .main ? SearchCoordinator(self) : nil
    }
    
    // MARK: - Loading Methods
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: logicController.load { [weak self] error, emptyContext in self?.loadHandler(error: error, emptyContext: emptyContext) }
        case .refresh: logicController.refresh { [weak self] error, emptyContext in self?.refreshHandler(error: error, emptyContext: emptyContext) }
        case .paginate: logicController.load { [weak self] error, emptyContext in self?.paginateHandler(error: error, emptyContext: emptyContext) }
        }
    }
    
}
