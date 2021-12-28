//
//  SettingsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 13/11/2021.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var themeType: ThemeType!
    
    @IBOutlet weak var currentThemeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getThemeType()
        currentThemeLabel.text = themeType.rawValue
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let alertController = UIAlertController(title: "Sign Out?", message: "You're about to sign out, continue?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut(action:)))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func signOut(action: UIAlertAction) {
        SessionManager.standard.signOut()
        performSegue(withIdentifier: "unwindToSplash", sender: self)
    }
    
    func setSelectedThemeType(themeType: ThemeType) {
        LibraryManager.standard.setThemeType(themeType: themeType)
        currentThemeLabel.text = themeType.rawValue
    }
    
    private func getThemeType() {
        let themeTypeResult = LibraryManager.standard.getThemeType()
        switch themeTypeResult {
        case .success(let themeType): self.themeType = themeType
        case .failure(LibraryError.userDefaults): themeType = .followSystem
        default: return
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "unwindToSplash" {
            let selectorVC = segue.destination as! ThemeSelectorViewController
            selectorVC.callback = setSelectedThemeType(themeType:)
        }
    }
    
}

class ThemeSelectorViewController: UITableViewController {
    
    var callback: ((ThemeType) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0: callback(.followSystem)
            case 1: callback(.light)
            case 2: callback(.dark)
            default: callback(.followSystem)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
}
