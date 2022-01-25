//
//  OrganizationViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import UIKit

class OrganizationViewController: SFDynamicTableViewController<OrganizationModel>, IBViewController {
    
    static var storyboardIdentifier = "OrganizationVC"
    
    override var model: List<OrganizationModel>! { return logicController.model }
    override var emptyViewModel: EmptyViewModel { return Constants.View.Empty.Organizations.viewModel }
    //override var cellConfigurator: TableViewCellConfigurator! { return OrganizationTableViewCellConfigurator() }
    
    private let logicController: OrganizationLogicController
    private var context: OrganizationContext { return logicController.context }
    
    private var searchCoordinator: SearchCoordinator<OrganizationModel>!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, context: OrganizationContext, contextParameters: Any? = nil) {
        logicController = OrganizationLogicController(context: context, contextParameters: contextParameters)
        super.init(coder: coder, tableViewDataSource: OrganizationTableViewDataSource(), tableViewDelegate: OrganizationTableViewDelegate())
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }
    
    static func instatiateWithContextAndParameters(with context: OrganizationContext, with contextParameters: Any? = nil) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> OrganizationViewController in
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
        debugPrint(String(describing: self) + " deallocated")
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
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        searchCoordinator = context == .main ? SearchCoordinator(self) : nil
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
