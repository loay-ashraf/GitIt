//
//  ResultsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class ResultsViewController<Type: Model>: UITableViewController {

    private weak var coordinator: SearchCoordinator<Type>!
    private var model: [Type] { return coordinator.results.items }
    
    // MARK: - Initialisation
    
    init(_ coordinator: SearchCoordinator<Type>) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureTableViewCell(for: indexPath)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentDetailViewController(for: indexPath)
    }
    
    // MARK: - Table View Context Menu
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
       return configureContextMenu(for: indexPath)
    }
    
    // MARK: - Table View Pagination
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NetworkManager.standard.isInternetConnected ? coordinator?.paginate() : nil
    }
    
    // MARK: - Table View Helper Methods
    
    private func configureTableView() {
        switch Type.self {
        case is UserModel.Type: tableView.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        case is RepositoryModel.Type: tableView.register(RepositoryTableViewCell.nib, forCellReuseIdentifier: RepositoryTableViewCell.reuseIdentifier)
        case is OrganizationModel.Type: tableView.register(OrganizationTableViewCell.nib, forCellReuseIdentifier: OrganizationTableViewCell.reuseIdentifier)
        default: return
        }
    }
    
    private func configureTableViewCell(for indexPath: IndexPath) -> UITableViewCell? {
        let cell = instantiateTableViewCell(for: indexPath)
        let item = model[indexPath.row]
            
        // Configure the cell...
        cell?.configure(with: item) { networkError in print(networkError) }
        
        return cell
    }
    
    private func instantiateTableViewCell(for indexPath: IndexPath) -> ReusableTableViewCell? {
        switch Type.self {
        case is UserModel.Type: return tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        case is RepositoryModel.Type: return tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.reuseIdentifier, for: indexPath) as! RepositoryTableViewCell
        case is OrganizationModel.Type: return tableView.dequeueReusableCell(withIdentifier: OrganizationTableViewCell.reuseIdentifier, for: indexPath) as! OrganizationTableViewCell
        default: return nil
        }
    }
    
    private func presentDetailViewController(for indexPath: IndexPath) {
        coordinator.willPresentModel(model: model[indexPath.row])
        let detailVC = instantiateDetailViewController(for: indexPath)
        let navController = UINavigationController(rootViewController: detailVC!)
        present(navController, animated: true, completion: nil)
    }
    
    private func instantiateDetailViewController(for indexPath: IndexPath) -> UIViewController? {
        switch Type.self {
        case is UserModel.Type: return UserDetailViewController.instatiateFromStoryboard(with: model[indexPath.row])
        case is RepositoryModel.Type: return RepositoryDetailViewController.instatiateFromStoryboard(with: model[indexPath.row])
        case is OrganizationModel.Type: return OrganizationDetailViewController.instatiateFromStoryboard(with: model[indexPath.row])
        default: return nil
        }
    }
    
    func configureContextMenu(for indexPath: IndexPath) -> UIContextMenuConfiguration {
        let actionProvider: UIContextMenuActionProvider = { actions -> UIMenu? in
            var bookmark: UIAction! = nil
            var share: UIAction! = nil
            let model = self.model[indexPath.row]
            let fetchResult = CoreDataManager.standard.exists(model)
            switch fetchResult {
            case .success(let exists): bookmark = exists ? ContextMenuActions.unbookmark(model).action : ContextMenuActions.bookmark(model).action
            case .failure(_): bookmark = ContextMenuActions.bookmark(model).action
            }
            share = ContextMenuActions.share(model).action
            return UIMenu(title: "Quick Actions", children: [bookmark, share])
        }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: actionProvider)
    }

}
