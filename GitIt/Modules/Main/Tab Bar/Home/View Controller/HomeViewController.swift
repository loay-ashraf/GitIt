//
//  HomeViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 07/11/2021.
//

import UIKit

class HomeViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigayionBarConstants.configureAppearance(for: navigationController?.navigationBar)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 0, row == 0 {
            let userVC = UserViewController.instatiateWithContextAndParameters(with: .main)
            navigationController?.pushViewController(userVC, animated: true)
        } else if section == 0, row == 1 {
            let repositoryVC = RepositoryViewController.instatiateWithContextAndParameters(with: .main)
            navigationController?.pushViewController(repositoryVC, animated: true)
        } else if section == 0, row == 2 {
            let organizationVC = OrganizationViewController.instatiateWithContextAndParameters(with: .main)
            navigationController?.pushViewController(organizationVC, animated: true)
        } else if section == 1, row == 0 {
            let repositoryVC = RepositoryDetailViewController.instatiateWithParameters(with: "loay-ashraf/GitIt")
            navigationController?.pushViewController(repositoryVC, animated: true)
        }
    }
    
}
