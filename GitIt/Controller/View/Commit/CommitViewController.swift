//
//  CommitViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitViewController: SFDynamicTableViewController<CommitModel> {
    
    override var model: List<CommitModel>! { return logicController.model }
    
    let logicController: CommitLogicController
    
    // MARK: - Initialisation
    
    init(parameters: String) {
        logicController = CommitLogicController(parameters: parameters)
        super.init(cellType: CommitTableViewCell.self, detailViewControllerType: CommitDetailViewController.self)
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
        
        title = "Commits".localized()
        navigationItem.largeTitleDisplayMode = .never
        
        subViewsOffsetSize = .subScreen
        
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
