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
        
        title = "Commits"
        navigationItem.largeTitleDisplayMode = .never
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
