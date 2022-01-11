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
        navigationItem.title = Constants.view.titles.settings
    }
    
    // MARK: - View Actions
    
    func clearData(action: UIAlertAction) {
        let _ = BookmarksManager.standard.clearAllBookmarks()
    }
    
    func signOut(action: UIAlertAction) {
        SessionManager.standard.signOut()
        performSegue(withIdentifier: "unwindToSplash", sender: self)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let alertTitle = Constants.view.alert.signOut.title
        let alertMessage = Constants.view.alert.signOut.message
        let signOutActionTitle = Constants.view.alert.signOut.signOutActionTitle
        let signOutAction = UIAlertAction(title: signOutActionTitle, style: .destructive, handler: signOut(action:))
        let cancelAction = Constants.view.alert.cancelAction
        AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .actionSheet, actions: [signOutAction,cancelAction])
    }
    
}

extension SettingsViewController: IASKSettingsDelegate {
    
    // MARK: - IASKSettings Delegate
    
    func settingsViewControllerDidEnd(_ settingsViewController: IASKAppSettingsViewController) { }
    
    func settingsViewController(_ settingsViewController: IASKAppSettingsViewController, buttonTappedFor specifier: IASKSpecifier) {
        if specifier.key == "clearButton" {
            let alertTitle = Constants.view.alert.clearData.title
            let alertMessage = Constants.view.alert.clearData.message
            let clearActionTitle = Constants.view.alert.clearData.clearActionTitle
            let clearAction = UIAlertAction(title: clearActionTitle, style: .destructive, handler: clearData(action:))
            let cancelAction = Constants.view.alert.cancelAction
            AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .actionSheet, actions: [clearAction,cancelAction])
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
}
