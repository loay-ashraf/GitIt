//
//  ResultsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class ResultsViewController<Type: Model>: SFDynamicTableViewController<Type> {
    
    override var model: List<Type>! { return logicController.model }
    
    private weak var delegate: ResultsDelegate!
    private var logicController: ResultsLogicController<Type>!
    
    // MARK: - Initialisation
    
    init(_ delegate: ResultsDelegate) {
        let cellType = Constants.Model.modelToCellType(type: Type.self)
        let detailViewControllerType = Constants.Model.modelToDetailViewControllerType(type: Type.self)
        super.init(cellType: cellType!, detailViewControllerType: detailViewControllerType!)
        self.delegate = delegate
        self.logicController = ResultsLogicController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Controller deallocated")
    }
    
    // MARK: - Loading Methods
    
    func loadResults(with keyword: String) {
        reset()
        logicController.keyword = keyword
        load(with: .initial)
    }
    
    override func load(with loadingViewState: LoadingViewState) {
        super.load(with: loadingViewState)
        switch loadingViewState {
        case .initial: logicController.load { [weak self] error, emptyContext in self?.loadHandler(error: error, emptyContext: emptyContext) }
        case .refresh: logicController.refresh { [weak self] error, emptyContext in self?.refreshHandler(error: error, emptyContext: emptyContext) }
        case .paginate: logicController.load { [weak self] error, emptyContext in self?.paginateHandler(error: error, emptyContext: emptyContext) }
        }
    }
    
    override func reset() {
        navigationController?.popToRootViewController(animated: false)
        logicController.reset()
        updateView()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        delegate.addModel(with: model.items[indexPath.row])
    }

}
