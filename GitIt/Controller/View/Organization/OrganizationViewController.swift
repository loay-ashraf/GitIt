//
//  OrganizationViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import UIKit

class OrganizationViewController: SFDynamicTableViewController<OrganizationModel> {
    
    override var model: List<OrganizationModel>! { return logicController.model }
    
    private let logicController: OrganizationLogicController
    private var context: OrganizationContext { return logicController.context }
    
    private var searchCoordinator: SearchCoordinator<OrganizationModel>!
    
    // MARK: - Initialisation
    
    init(context: OrganizationContext, contextParameters: Any? = nil) {
        logicController = OrganizationLogicController(context: context, contextParameters: contextParameters)
        super.init(cellType: OrganizationTableViewCell.self, detailViewControllerType: OrganizationDetailViewController.self)
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
