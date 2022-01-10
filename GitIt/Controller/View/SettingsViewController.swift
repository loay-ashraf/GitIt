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
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getThemeType()
        currentThemeLabel.text = themeType.rawValue
        signOutButton.cornerRadius = 10.0
        signOutButton.cornerCurve = .continuous
        signOutButton.masksToBounds = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func signOut(action: UIAlertAction) {
        SessionManager.standard.signOut()
        performSegue(withIdentifier: "unwindToSplash", sender: self)
    }
    
    func setSelectedThemeType(themeType: ThemeType) {
        self.themeType = themeType
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
    
    @IBAction func signOut(_ sender: UIButton) {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive, handler: signOut(action:))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertHelper.showAlert(title: "Sign Out?", message: "If you sign out all of your data will be erased, continue?", style: .actionSheet, actions: [signOutAction,cancelAction])
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "unwindToSplash" {
            let selectorVC = segue.destination as! ThemeSelectorViewController
            selectorVC.callback = setSelectedThemeType(themeType:)
            selectorVC.themeType = themeType
        }
    }
    
}

class ThemeSelectorViewController: UITableViewController {
    
    var callback: ((ThemeType) -> Void)!
    var themeType: ThemeType!
    var selectedRowIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch themeType {
        case .followSystem: selectedRowIndex = 0
        case .light: selectedRowIndex = 1
        case .dark: selectedRowIndex = 2
        default: break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeTypeCell")!
        switch indexPath.row {
        case 0: cell.textLabel?.text = ThemeType.followSystem.rawValue
        case 1: cell.textLabel?.text = ThemeType.light.rawValue
        case 2: cell.textLabel?.text = ThemeType.dark.rawValue
        default: break
        }
        if selectedRowIndex == indexPath.row { cell.accessoryType = .checkmark }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            case 0: callback(.followSystem)
            case 1: callback(.light)
            case 2: callback(.dark)
            default: break
        }
    }
    
}
