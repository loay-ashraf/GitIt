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
        if section == 0 {
            let userVC = UserViewController.instatiate(context: .main as UserContext)
            navigationController?.pushViewController(userVC, animated: true)
        } else if section == 1 {
            let repositoryVC = RepositoryViewController.instatiate(context: .main as RepositoryContext)
            navigationController?.pushViewController(repositoryVC, animated: true)
        } else if section == 2 {
            let organizationVC = OrganizationViewController.instatiate(context: .main as OrganizationContext)
            navigationController?.pushViewController(organizationVC, animated: true)
        } else if section == 3 {
            let repositoryVC = RepositoryDetailViewController.instatiate(parameter: "loay-ashraf/GitIt")
            navigationController?.pushViewController(repositoryVC, animated: true)
        }
    }
    
}
