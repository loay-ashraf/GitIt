//
//  ExploreViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 07/11/2021.
//

import UIKit

class ExploreViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            let userVC = UserViewController.instatiateWithContextAndParameters(with: .main)
            navigationController?.pushViewController(userVC, animated: true)
        } else if row == 1 {
            let repositoryVC = RepositoryViewController.instatiateWithContextAndParameters(with: .main)
            navigationController?.pushViewController(repositoryVC, animated: true)
        } else if row == 2 {
            let organizationVC = OrganizationViewController.instatiateWithContextAndParameters(with: .main)
            navigationController?.pushViewController(organizationVC, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
