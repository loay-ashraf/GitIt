//
//  CommitTableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import Foundation
import UIKit

extension CommitViewController {
    
    private var model: List<CommitModel> { return logicController.model }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.refreshControl!.isRefreshing { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: CommitTableViewCell.reuseIdentifier, for: indexPath) as! CommitTableViewCell
        let repository = model.items[indexPath.row]
        
        // Configure the cell...
        cell.configure(with: repository)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commitModel = model.items[indexPath.row]
        let commitDetailVC = CommitDetailViewController.instatiateFromStoryboard(with: commitModel)
        navigationController?.pushViewController(commitDetailVC, animated: true)
    }
    
    // MARK: - Table View Context Menu
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(indexPath: indexPath)
    }
    
    // MARK: - Table View Refresh
    
    @objc func handleRefreshControl() {
        NetworkReachability.shared.isInternetConnected ? logicController.refresh(then: render(_:)) : tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table View Pagination
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NetworkReachability.shared.isInternetConnected ? paginate() : nil
    }
    
    // MARK: - Table View Helper Methods
    
    func configureTableView() {
        tableView.register(CommitTableViewCell.nib, forCellReuseIdentifier: CommitTableViewCell.reuseIdentifier)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
         let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
             var share: UIAction! = nil
             let repositoryModel = self.model.items[indexPath.row]
             share = ContextMenuActions.share(repositoryModel).action
             return UIMenu(title: "Quick Actions", children: [share])
         }
         return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
     }
    
    private func paginate() {
        let lastRowIndex = tableView.indexPathsForVisibleRows?.last?.row
        if let lastRowIndex = lastRowIndex {
            if model.isPaginable, !loadingSpinner.isActive, lastRowIndex + 1 == model.items.count {
                render(.paginating)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.logicController.load { [weak self] state in
                        self?.render(state)
                    }
                }
            }
        }
    }
    
}
