//
//  SettingsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 13/11/2021.
//

import UIKit
import InAppSettingsKit

class SettingsViewController: IASKAppSettingsViewController {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    // MARK: - View Actions
    
    func clearData(action: UIAlertAction) {
        let _ = BookmarksManager.standard.clearAllBookmarks()
    }
    
    func signOut(action: UIAlertAction) {
        SessionManager.standard.signOut()
        performSegue(withIdentifier: "unwindToSplash", sender: self)
    }
    
}

extension SettingsViewController: IASKSettingsDelegate {
    
    // MARK: - IASKSettings Delegate
    
    func settingsViewControllerDidEnd(_ settingsViewController: IASKAppSettingsViewController) { }
    
    func settingsViewController(_ settingsViewController: IASKAppSettingsViewController, buttonTappedFor specifier: IASKSpecifier) {
        if specifier.key == "clearButton" {
            let clearAction = UIAlertAction(title: "Clear Data", style: .destructive, handler: clearData(action:))
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            AlertHelper.showAlert(title: "Clear Data?", message: "You're about to erase your local data, proceed?", style: .actionSheet, actions: [clearAction,cancelAction])
        }
    }
    
    func settingsViewController(_ settingsViewController: UITableViewController & IASKViewController, heightFor specifier: IASKSpecifier) -> CGFloat {
        return 45.0
    }
    
    func settingsViewController(_ settingsViewController: UITableViewController & IASKViewController, cellFor specifier: IASKSpecifier) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "signOutCell")
        return cell
    }
    
    func settingsViewController(_ settingsViewController: IASKAppSettingsViewController, didSelectCustomViewSpecifier specifier: IASKSpecifier) {
        if specifier.key == "soButton" {
            settingsViewController.tableView.deselectRow(at: IndexPath(row: 0, section: 2), animated: true)
            let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut(action:))
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            AlertHelper.showAlert(title: "Sign Out?", message: "If you sign out all of your data will be erased, continue?", style: .actionSheet, actions: [signOutAction,cancelAction])
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
}
