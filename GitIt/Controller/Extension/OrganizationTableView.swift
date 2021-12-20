//
//  OrganizationTableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import Foundation
import UIKit

extension OrganizationViewController {
    
    private var model: List<OrganizationModel> { return logicController.model }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.refreshControl!.isRefreshing { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationTableViewCell.reuseIdentifier, for: indexPath) as! OrganizationTableViewCell
        let organization = model.items[indexPath.row]
        
        // Configure the cell...
        cell.configure(with: organization) { networkError in print(networkError) }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let organizationModel = model.items[indexPath.row]
        let organizationDetailVC = OrganizationDetailViewController.instatiateFromStoryboard(with: organizationModel)
        navigationController?.pushViewController(organizationDetailVC, animated: true)
    }
    
    // MARK: - Table View Context Menu
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(indexPath: indexPath)
    }
    
    // MARK: - Table View Refresh
    
    @objc func handleRefreshControl() {
        NetworkManager.standard.isInternetConnected ? logicController.refresh(then: render(_:)) : tableView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table View Pagination
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NetworkManager.standard.isInternetConnected ? paginate() : nil
    }
    
    // MARK: - Table View Helper Methods
    
    func configureTableView() {
        tableView.register(OrganizationTableViewCell.nib, forCellReuseIdentifier: OrganizationTableViewCell.reuseIdentifier)
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
         let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
             var bookmark: UIAction! = nil
             var share: UIAction! = nil
             let userModel = self.model.items[indexPath.row]
             if DataController.standard.exists(userModel) {
                 bookmark = ContextMenuActions.unbookmark(userModel).action
             } else {
                 bookmark = ContextMenuActions.bookmark(userModel).action
             }
             share = ContextMenuActions.share(userModel).action
             return UIMenu(title: "Quick Actions", children: [bookmark, share])
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
