//
//  ProfileViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 07/11/2021.
//

import UIKit
import CoreData

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: AsyncUIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let headerView = tableView.tableHeaderView else {
            return
        }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    @IBAction func share(_ sender: Any) {
        let webURL = SessionManager.standard.sessionUser.htmlURL
        URLHelper.shareURL(webURL)
    }

}

extension ProfileViewController {
    
    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        
        avatarImageView.cornerRadius = 64.0
        avatarImageView.cornerCurve = .continuous
        avatarImageView.masksToBounds = true
    }
    
    private func updateUI() {
        avatarImageView.load(at: SessionManager.standard.sessionUser.avatarURL) { networkError in print(networkError) }
        if SessionManager.standard.sessionUser.name != nil {
            fullNameLabel.text = SessionManager.standard.sessionUser.name
        } else  {
            fullNameLabel.isHidden = true
        }
        loginLabel.text = SessionManager.standard.sessionUser.login
        if SessionManager.standard.sessionUser.bio != nil {
            bioLabel.text = SessionManager.standard.sessionUser.bio
        } else {
            bioLabel.isHidden = true
        }
        if SessionManager.standard.sessionUser.location != nil {
            locationLabel.text = SessionManager.standard.sessionUser.location
        } else {
            locationStackView.isHidden = true
        }
        followersLabel.text = String(SessionManager.standard.sessionUser.followers!)
        followingLabel.text = String(SessionManager.standard.sessionUser.following!)
    }

}
