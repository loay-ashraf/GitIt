//
//  BookmarksViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class BookmarksViewController: SFDynamicTableViewController<Any> {
    
    override var model: List<Any>! { return List<Any>(with: logicController.model) }
    
    private let logicController: BookmarksLogicController
    
    @IBOutlet weak var selectorSegmentedControl: UISegmentedControl!
    
    required init?(coder: NSCoder) {
        logicController = BookmarksLogicController()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load(with: .initial)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load(with: .initial)
    }
    
    override func configureView() {
        super.configureView()
    
        cellType = UserTableViewCell.self
        detailViewControllerType = UserDetailViewController.self
        logicController.setModelType(modelType: UserModel.self)
        
        registerCell(cellType: UserTableViewCell.self)
        registerCell(cellType: RepositoryTableViewCell.self)
        registerCell(cellType: OrganizationTableViewCell.self)
        disableRefreshControl()
        subViewsOffsetSize = .mainScreenWithSearch
    }
    
    @IBAction func selectorChanged(_ sender: Any) {
        switch selectorSegmentedControl.selectedSegmentIndex {
        case 0: cellType = UserTableViewCell.self
            detailViewControllerType = UserDetailViewController.self
            logicController.setModelType(modelType: UserModel.self)
        case 1: cellType = RepositoryTableViewCell.self
            detailViewControllerType = RepositoryDetailViewController.self
            logicController.setModelType(modelType: RepositoryModel.self)
        case 2: cellType = OrganizationTableViewCell.self
            detailViewControllerType = OrganizationDetailViewController.self
            logicController.setModelType(modelType: OrganizationModel.self)
        default: break
        }
        load(with: .initial)
    }
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: logicController.load { [weak self] error, emptyContext in self?.loadHandler(error: error, emptyContext: emptyContext) }
        case .paginate: logicController.load { [weak self] error, emptyContext in self?.paginateHandler(error: error, emptyContext: emptyContext) }
        default: break
        }
    }

}
