//
//  SettingsViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 13/11/2021.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var theme: ThemeType!
    
    @IBOutlet weak var currentThemeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theme = DataManager.shared.getThemeType()
        currentThemeLabel.text = theme.stringValue
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let alertController = UIAlertController(title: "Sign Out", message: "You're about to sign out, continue?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut(action:)))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func signOut(action: UIAlertAction) {
        SessionManager.standard.signOut(currentViewController: self)
    }
    
    func getSelectedTheme(themeType: ThemeType) {
        currentThemeLabel.text = themeType.stringValue
        DataManager.shared.setThemeType(themeType: themeType)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectorVC = segue.destination as! ThemeSelectorViewController
        selectorVC.callback = getSelectedTheme(themeType:)
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
