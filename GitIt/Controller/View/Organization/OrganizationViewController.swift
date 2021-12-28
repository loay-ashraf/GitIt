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
