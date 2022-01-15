//
//  CommitViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitViewController: SFDynamicTableViewController<CommitModel>, IBViewController {
    
    static var storyboardIdentifier = "CommitVC"
    
    override var model: List<CommitModel>! { return logicController.model }
    override var emptyModel: EmptyViewModel { return Constants.View.Empty.commits.viewModel }
    
    let logicController: CommitLogicController
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, parameters: String) {
        logicController = CommitLogicController(parameters: parameters)
        super.init(coder: coder, cellType: CommitTableViewCell.self, detailViewControllerType: CommitDetailViewController.self)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }
    
    static func instatiateWithParameters(with parameters: Any) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> CommitViewController in
                    self.init(coder: coder, parameters: parameters as! String)!
                })
    }
    
    static func instatiateWithModel(with model: Any) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using parameters")
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
        case .initial: logicController.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: logicController.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: logicController.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }

}
