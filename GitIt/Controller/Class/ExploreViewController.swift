//
//  ExploreViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 07/11/2021.
//

import UIKit

class ExploreViewController: UITableViewController {
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == 0 {
            let userVC = UserViewController(context: .main)
            navigationController?.pushViewController(userVC, animated: true)
        } else if row == 1 {
            let repositoryVC = RepositoryViewController(context: .main)
            navigationController?.pushViewController(repositoryVC, animated: true)
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