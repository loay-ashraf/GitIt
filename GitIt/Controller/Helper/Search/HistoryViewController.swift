//
//  HistoryViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class HistoryViewController<Type: Model>: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private weak var coordinator: SearchCoordinator<Type>!
    private weak var headerView: HistoryHeaderView!
    private var historyModels: NSMutableOrderedSet! { return coordinator.searchHistoryModels }
    private var historyKeywords: NSMutableOrderedSet! { return coordinator.searchHistoryKeywords }

    // MARK: - Initialisation
    
    init(_ coordinator: SearchCoordinator<Type>) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUI()
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyKeywords != nil ? historyKeywords.count : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseIdentifier, for: indexPath) as! HistoryTableViewCell
        let item = historyKeywords[indexPath.row]
            
        // Configure the cell...
        cell.configure(text: item as! String)
            
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let keyWord = historyKeywords[indexPath.row] as! String
        coordinator.addToHistory(keyWord: keyWord)
        coordinator.historySearch(keyWord: keyWord)
        updateTableView()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            coordinator.deleteFromHistory(keyWord: historyKeywords[indexPath.row] as! String)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        updateTableView()
    }
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyModels != nil ? historyModels.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCollectionViewCell.reuseIdentifier, for: indexPath) as! HistoryCollectionViewCell
        let item = historyModels[indexPath.row]
        
        // Configure the cell...
        cell.configure(with: item as! Type)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        headerView.collectionView.deselectItem(at: indexPath, animated: true)
        presentDetailViewController(for: indexPath)
        coordinator.addToHistory(model: historyModels[indexPath.row] as! Type)
        updateCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureCollectionViewContextMenu(indexPath: indexPath)
    }
    
}

extension HistoryViewController {
    
    // MARK: - UI Helper Methods
    
    func updateUI() {
        updateTableView()
        updateCollectionView()
        layoutUI()
    }
    
    private func layoutUI() {
        if historyKeywords.array.isEmpty, historyModels.array.isEmpty {
            hideTableHeaderView()
        } else if historyModels.array.isEmpty {
            showTableHeaderView()
            headerView.hideCollectionView()
        } else {
            showTableHeaderView()
            headerView.showCollectionView()
        }
        fitTableHeaderView()
    }
    
    private func updateTableView() {
        tableView.reloadData()
    }
    
    private func updateCollectionView() {
        headerView.reloadData()
    }
    
    private func configureUI() {
        configureTableView()
        configureTableHeaderView()
    }
    
    private func configureTableView() {
        tableView.register(HistoryTableViewCell.nib, forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.bounces = false
    }
    
    private func configureTableHeaderView() {
        headerView = HistoryHeaderView.instanceFromNib()
        headerView.configureDelegate(delegate: self)
        headerView.configureDataSource(dataSource: self)
        headerView.configureButtonAction { [weak self] in self?.clear() }
        tableView.tableHeaderView = headerView
    }
    
    private func fitTableHeaderView() {
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    private func showTableHeaderView() {
        headerView.isHidden = false
    }
    
    private func hideTableHeaderView() {
        headerView.isHidden = true
    }
    
    private func clear() {
        let clearHistoryAlertController = UIAlertController(title: "Clear search history?", message: "This can't be undone and you'll remove your search history.", preferredStyle: .alert)
        clearHistoryAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        clearHistoryAlertController.addAction(UIAlertAction(title: "Clear", style: .destructive) { action in
            self.coordinator.clearHistory()
            self.updateUI()
        })
        present(clearHistoryAlertController, animated: true, completion: nil)
    }
    
    private func presentDetailViewController(for indexPath: IndexPath) {
        let detailVC = instantiateDetailViewController(for: indexPath)
        let navController = UINavigationController(rootViewController: detailVC!)
        present(navController, animated: true, completion: nil)
    }
    
    private func instantiateDetailViewController(for indexPath: IndexPath) -> UIViewController? {
        switch Type.self {
        case is UserModel.Type: return UserDetailViewController.instatiateFromStoryboard(with: historyModels[indexPath.row] as! UserModel)
        case is RepositoryModel.Type: return  RepositoryDetailViewController.instatiateFromStoryboard(with: historyModels[indexPath.row] as! RepositoryModel)
        case is OrganizationModel.Type: return OrganizationDetailViewController.instatiateFromStoryboard(with: historyModels[indexPath.row]as! OrganizationModel)
        default: return nil
        }
    }
    
    private func configureCollectionViewContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
            var delete: UIAction! = nil
            let model = self.historyModels[indexPath.row]
            delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: [.destructive]) { action in
                self.coordinator.deleteFromHistory(model: model as! Type)
                self.headerView.deleteItems(at: [indexPath])
                self.updateCollectionView()
                self.layoutUI()
            }
            return UIMenu(children: [delete])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }
    
}
