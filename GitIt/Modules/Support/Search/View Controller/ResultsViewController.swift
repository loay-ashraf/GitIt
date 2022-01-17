//
//  ResultsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class ResultsViewController<Type: Model>: SFDynamicTableViewController<Type> {
    
    override var model: List<Type>! { return logicController.model }
    override var emptyViewModel: EmptyViewModel { return Constants.View.Empty.searchResults.viewModel }
    //override var cellConfigurator: TableViewCellConfigurator! { return UserTableViewCellConfigurator() }
    
    private weak var delegate: ResultsDelegate!
    private var logicController: ResultsLogicController<Type>!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, delegate: ResultsDelegate) {
        let cellType = Constants.Model.modelToCellType(type: Type.self)
        let detailViewControllerType = Constants.Model.modelToDetailViewControllerType(type: Type.self)
        super.init(coder: coder, tableViewDataSource: TableViewDataSource<Type>(), tableViewDelegate: TableViewDelegate<Type>())
        self.delegate = delegate
        logicController = ResultsLogicController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func instatiateFromStoryboard(with delegate: ResultsDelegate) -> ResultsViewController<Type> {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        return storyBoard.instantiateViewController(identifier: "ResultsVC", creator: {coder -> ResultsViewController<Type> in
                        self.init(coder: coder, delegate: delegate)!
                })
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
        case .initial: logicController.load { [weak self] error in self?.loadHandler(error: error) }
        case .refresh: logicController.refresh { [weak self] error in self?.refreshHandler(error: error) }
        case .paginate: logicController.load { [weak self] error in self?.paginateHandler(error: error) }
        }
    }
    
    override func reset() {
        logicController.reset()
        updateView()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        delegate.addModel(with: model.items[indexPath.row])
    }

}
