//
//  OrganizationViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import UIKit

class OrganizationViewController: SFDynamicTableViewController<OrganizationCellViewModel>, StoryboardableViewController {
    
    // MARK: - Properties
    
    static var storyboardIdentifier = "OrganizationVC"
    
    private var context: OrganizationContext
    
    private var searchCoordinator: SearchCoordinator<OrganizationModel>!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, context: OrganizationContext) {
        self.context = context
        super.init(coder: coder, tableViewDataSource: cvx(), tableViewDelegate: dcf())
        viewModel = OrganizationViewModel(context: context)
        emptyViewModel = Constants.View.Empty.Organizations.viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, coder initializer not implemented.")
    }
    
    static func instatiate<T: ViewControllerContext>(context: T) -> UIViewController {
        if let organizationContext = context as? OrganizationContext {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> OrganizationViewController in
                        self.init(coder: coder, context: organizationContext)!
            })
        } else {
            return UIViewController()
        }
    }
    
    static func instatiate(parameter: String) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using context")
    }
    
    static func instatiate<T: CellViewModel>(cellViewModel: T) -> UIViewController  {
        fatalError("Fatal Error, This View controller is instaniated only using context")
    }
    
    static func instatiate<T: Model>(model: T) -> UIViewController  {
        fatalError("Fatal Error, This View controller is instaniated only using context")
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
        
        title = context.title
        switch context {
        case .main: navigationItem.largeTitleDisplayMode = .always
        default: navigationItem.largeTitleDisplayMode = .never
        }
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
//        switch context {
//        case .main: searchCoordinator = SearchCoordinator(self)
//        default: searchCoordinator = nil
//        }
    }
    
    // MARK: - Loading Methods
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: viewModel.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: viewModel.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: viewModel.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }
    
}
