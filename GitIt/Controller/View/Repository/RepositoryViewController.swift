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
        super.init(cellType: RepositoryTableViewCell.self, detailViewControllerType: RepositoryDetailViewController.self)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated from storyboard.")
    }
    
    deinit {
        print("Controller deallocated")
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
