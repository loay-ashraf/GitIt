//
//  HistoryViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/12/2021.
//

import UIKit

class HistoryViewController<Type: Model>: SFViewController {
    
    weak var delegate: HistoryDelegate!
    var logicController: HistoryLogicController<Type>!
    
    var collectionViewController: HistoryCollectionViewController!
    var tableViewController: HistoryTableViewController!
    
    var collectionView: SFDynamicCollectionView { return collectionViewController.xCollectionView }
    var tableView: SFDynamicTableView { return tableViewController.xTableView }
    
    // MARK: - View Outlets
    
    @IBOutlet weak var headerTitleStackView: UIStackView!
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var collectionContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableContainerView: UIView!
    @IBOutlet weak var tableContainerHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, delegate: HistoryDelegate) {
        super.init(coder: coder)
        self.delegate = delegate
        logicController = HistoryLogicController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func instatiateFromStoryboard(with delegate: HistoryDelegate) -> HistoryViewController<Type> {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        return storyBoard.instantiateViewController(identifier: "HistoryVC", creator: {coder -> HistoryViewController<Type> in
                        self.init(coder: coder, delegate: delegate)!
                })
    }
    
    deinit {
        print("Controller deallocated")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        collectionViewController?.delegate = self
        collectionViewController?.detailViewControllerType = Constants.Model.modelToDetailViewControllerType(type: Type.self)
        tableViewController?.delegate = self
    }
    
    func layoutView() {
        let headerShouldBeHidden = logicController.history.models.isEmpty && logicController.history.keywords.isEmpty
        switch headerShouldBeHidden {
        case true: headerTitleStackView.isHidden = true
                   xView.transition(to: .empty(.searchHistory))
        case false: headerTitleStackView.isHidden = false
                    xView.transition(to: .presenting)
        }
        layoutCollectionView()
        layoutTableView()
    }
    
    func layoutCollectionView() {
        let collectionShouldBeHidden = logicController.history.models.isEmpty
        let collectionContentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        switch collectionShouldBeHidden {
        case true: collectionContainerView.isHidden = true
                   collectionContainerHeightConstraint.constant = 0.0
        case false: collectionContainerView.isHidden = false
                    collectionContainerHeightConstraint.constant = collectionContentHeight
        }
    }
    
    func layoutTableView() {
        let tableShouldBeHidden = logicController.history.keywords.isEmpty
        let tableContentHeight = tableView.contentSize.height
        switch tableShouldBeHidden {
        case true: tableContainerView.isHidden = true
                   tableContainerHeightConstraint.constant = 0.0
        case false: tableContainerView.isHidden = false
                    tableContainerHeightConstraint.constant = tableContentHeight
        }
    }
    
    override func updateView() {
        collectionViewController.updateView()
        tableViewController.updateView()
    }
    
    // MARK: - View Actions
    
    @IBAction func clearAction(_ sender: UIButton) {
        let alertTitle = Constants.View.alert.clearSearchHistory.title
        let alertMessage = Constants.View.alert.clearSearchHistory.message
        let cancelAction = Constants.View.alert.cancelAction
        let clearActionTitle = Constants.View.alert.clearSearchHistory.clearActionTitle
        let clearAction = UIAlertAction(title: clearActionTitle, style: .destructive) { action in
        self.logicController.clear()
        self.layoutView()
        }
        AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .actionSheet, actions: [cancelAction,clearAction])
    }
    
    // MARK: - Navigation Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let collectionViewController as HistoryCollectionViewController:
            self.collectionViewController = collectionViewController
        case let tableViewController as HistoryTableViewController:
            self.tableViewController = tableViewController
        default: break
        }
        if collectionViewController != nil, tableViewController != nil {
            configureView()
            load()
        }
    }
    
    // MARK: - Load, Reset Methods
    
    override func load() {
        super.load()
        logicController.load { [weak self] error, emptyContext in self?.loadHandler(error: error, emptyContext: emptyContext) }
    }
    
    func reset() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    // MARK: - Load Handler Methods
    
    override func loadHandler(error: Error?, emptyContext: EmptyContext?) {
        super.loadHandler(error: error, emptyContext: emptyContext)
        layoutView()
    }

}
