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
        navigationItem.title = Constants.View.Title.settings
    }
    
    // MARK: - View Actions
    
    func clearData(action: UIAlertAction) {
        try? DataManager.standard.clearData()
    }
    
    func signOut() {
        SessionManager.standard.signOut()
        try? DataManager.standard.clearAllData()
        performSegue(withIdentifier: "unwindToSplash", sender: self)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        AlertHelper.showAlert(alert: .signOut({ [weak self] in
            self?.signOut()
        }))
    }
    
}

extension SettingsViewController: IASKSettingsDelegate {
    
    // MARK: - IASKSettings Delegate
    
    func settingsViewControllerDidEnd(_ settingsViewController: IASKAppSettingsViewController) { }
    
    func settingsViewController(_ settingsViewController: IASKAppSettingsViewController, buttonTappedFor specifier: IASKSpecifier) {
        if specifier.key == "clButton" {
            let appURL = URL(string: UIApplication.openSettingsURLString)!
            if UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL)
            }
        } else if specifier.key == "clearButton" {
            AlertHelper.showAlert(alert: .clearData)
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
}
