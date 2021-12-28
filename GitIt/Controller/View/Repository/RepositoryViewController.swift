//
//  RepositoryViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class RepositoryViewController: SFDynamicTableViewController<RepositoryModel> {

    override var model: List<RepositoryModel>! { return logicController.model }
    
    private let logicController: RepositoryLogicController
    private var context: RepositoryContext { return logicController.context }
    
    private var searchCoordinator: SearchCoordinator<RepositoryModel>!
    
    // MARK: - Initialisation
    
    init(context: RepositoryContext, contextParameters: Any? = nil) {
        logicController = RepositoryLogicController(context: context, contextParameters: contextParameters)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated from storyboard.")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load(with: .initial)
    }
    
    // MARK: - UI Helper Methods
    
    override func configureView() {
        super.configureView()
        
        title = context.titleValue
        navigationItem.largeTitleDisplayMode = context == .main ? .always : .never
        
        searchCoordinator = context == .main ? SearchCoordinator(self) : nil
    }
    
    // MARK: - Loading Methods
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: logicController.load(then: loadHandler(error:))
        case .refresh: logicController.refresh(then: refreshHandler(error:))
        case .paginate: logicController.load(then: paginateHandler(error:))
        }
    }

}
