//
//  SearchHistoryViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/12/2021.
//

import UIKit

class SearchHistoryViewController<T: SearchHistoryViewModel>: SFViewController {
    
    // MARK: - Properties
    
    weak var delegate: SearchHistoryDelegate!
    var viewModel = T()
    
    var collectionViewDataSource: CollectionViewDataSource<T.CollectionCellViewModelType>!
    var collectionViewDelegate: SearchHistoryCollectionViewDelegate<T.CollectionCellViewModelType>!
    var tableViewDataSource: SearchHistoryTableViewDataSource!
    var tableViewDelegate: SearchHistoryTableViewDelegate!
    
    // MARK: - View Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerTitleStackView: UIStackView!
    @IBOutlet weak var collectionView: CollectionView!
    @IBOutlet weak var tableView: TableView!
    @IBOutlet weak var collectionContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableContainerHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, delegate: SearchHistoryDelegate) {
        super.init(coder: coder)
        self.delegate = delegate
        emptyViewModel = EmptyConstants.SearchHistory.viewModel
        subscribeToKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static func instatiateFromStoryboard(with delegate: SearchHistoryDelegate) -> SearchHistoryViewController<T> {
        let storyBoard = UIStoryboard(name: "Search", bundle: nil)
        return storyBoard.instantiateViewController(identifier: "HistoryVC", creator: {coder -> SearchHistoryViewController<T> in
            self.init(coder: coder, delegate: delegate)!
                })
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
        unSubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
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
        
        collectionView.cornerRadius = 10.0
        collectionView.cornerCurve = .continuous
        collectionViewDataSource = SearchHistoryCollectionViewDataSource<T.CollectionCellViewModelType>.raw()
        collectionViewDelegate = SearchHistoryCollectionViewDelegate<T.CollectionCellViewModelType>(collectionDelegate: self)
        collectionView.setDataSource(collectionViewDataSource)
        collectionView.setDelegate(collectionViewDelegate)
    
        tableView.cornerRadius = 10.0
        tableView.cornerCurve = .continuous
        tableViewDataSource = SearchHistoryTableViewDataSource(tableDelegate: self)
        tableViewDelegate = SearchHistoryTableViewDelegate(tableDelegate: self)
        tableView.setDataSource(tableViewDataSource)
        tableView.setDelegate(tableViewDelegate)
    }
    
    func layoutView() {
        let headerShouldBeHidden = viewModel.objectCellViewModels.isEmpty && viewModel.queryCellViewModels.isEmpty
        switch headerShouldBeHidden {
        case true: headerTitleStackView.isHidden = true
                   xView.transition(to: .empty(emptyViewModel))
        case false: headerTitleStackView.isHidden = false
                    xView.transition(to: .presenting)
        }
        layoutCollectionView()
        layoutTableView()
    }
    
    func layoutCollectionView() {
        let collectionShouldBeHidden = viewModel.objectCellViewModels.isEmpty
        let collectionContentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        switch collectionShouldBeHidden {
        case true: collectionView.isHidden = true
                   collectionContainerHeightConstraint.constant = 0.0
        case false: collectionView.isHidden = false
                    collectionContainerHeightConstraint.constant = collectionContentHeight
        }
    }
    
    func layoutTableView() {
        let tableShouldBeHidden = viewModel.queryCellViewModels.isEmpty
        let tableContentHeight = tableView.contentSize.height
        switch tableShouldBeHidden {
        case true: tableView.isHidden = true
                   tableContainerHeightConstraint.constant = 0.0
        case false: tableView.isHidden = false
                    tableContainerHeightConstraint.constant = tableContentHeight
        }
    }
    
    override func updateView() {
        updateCollectionView()
        updateTableView()
    }
    
    func updateCollectionView() {
        synchronizeCollectionView()
        collectionView.reloadData()
    }
    
    func updateTableView() {
        synchronizeTableView()
        tableView.reloadData()
    }
    
    // MARK: - View Synchronization Methods
    
    func synchronizeCollectionView() {
        collectionViewDataSource.cellViewModels = viewModel.objectCellViewModels
        collectionViewDelegate.cellViewModels = viewModel.objectCellViewModels
    }
    
    func synchronizeTableView() {
        tableViewDataSource.cellViewModels = viewModel.queryCellViewModels
        tableViewDelegate.cellViewModels = viewModel.queryCellViewModels
    }
    
    // MARK: - View Actions
    
    @IBAction func clear(_ sender: UIButton) {
        AlertHelper.showAlert(alert: .clearSearchHistory({ [weak self] in
            self?.viewModel.clear()
            self?.updateView()
            self?.layoutView()
        }))
    }
    
    // MARK: - Load, Reset Methods
    
    override func load() {
        super.load()
        viewModel.load { [weak self] error in self?.loadHandler(error: error) }
    }
    
    func reset() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    // MARK: - Load Handler Methods
    
    override func loadHandler(error: Error?) {
        if let error = error {
            xView.transition(to: .failed(.initial(error)))
        } else {
            layoutView()
        }
    }
    
    // MARK: - Keyboard Adjustment Methods
    
    func subscribeToKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func unSubscribeFromKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

}
