//
//  ProfileViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 07/11/2021.
//

import UIKit

class ProfileViewController: SFStaticTableViewController {
    
    // MARK: - View Outlets
    
    @IBOutlet weak var avatarImageView: SFImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var companyStackView: UIStackView!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var blogStackView: UIStackView!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var twitterStackView: UIStackView!
    @IBOutlet weak var followStackView: UIStackView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if subViewsOffsetSize != .searchScreen {
            subViewsOffsetSize = .subScreen
        } else {
            subViewsOffsetSize = .searchScreenWithNavBar
        }
        
        avatarImageView.cornerRadius = 64.0
        avatarImageView.cornerCurve = .continuous
        avatarImageView.masksToBounds = true
        
        let avatarLongPressesGesture = UILongPressGestureRecognizer(target: self, action: #selector(saveAvatar))
        avatarImageView.addGestureRecognizer(avatarLongPressesGesture)
        avatarImageView.isUserInteractionEnabled = true
        
        let blogLabelTapGesture = UITapGestureRecognizer(target: self,action: #selector(self.goToBlog))
        blogLabel.addGestureRecognizer(blogLabelTapGesture)
        blogLabel.isUserInteractionEnabled = true
        
        let emailLabelTapGesture = UITapGestureRecognizer(target: self,action: #selector(self.composeMail))
        emailLabel.addGestureRecognizer(emailLabelTapGesture)
        emailLabel.isUserInteractionEnabled = true
        
        let twitterLabelTapGesture = UITapGestureRecognizer(target: self,action: #selector(self.goToTwitter))
        twitterLabel.addGestureRecognizer(twitterLabelTapGesture)
        twitterLabel.isUserInteractionEnabled = true
        
        let followersLabelTapGesture = UITapGestureRecognizer(target: self,action: #selector(self.showFollowers))
        followersLabel.addGestureRecognizer(followersLabelTapGesture)
        followersLabel.isUserInteractionEnabled = true
        
        let followingLabelTapGesture = UITapGestureRecognizer(target: self,action: #selector(self.showFollowing))
        followingLabel.addGestureRecognizer(followingLabelTapGesture)
        followingLabel.isUserInteractionEnabled = true
    }
    
    override func updateView() {
        if let model = SessionManager.standard.sessionUser {
            avatarImageView.load(at: model.avatarURL)
            if model.name != nil {
                fullNameLabel.text = model.name
            } else  {
                fullNameLabel.isHidden = true
            }
            loginLabel.text = model.login
            if model.bio != nil {
                bioLabel.text = model.bio
            } else {
                bioLabel.isHidden = true
            }
            if model.company != nil {
                companyLabel.text = model.company
            } else {
                companyStackView.isHidden = true
            }
            if model.location != nil {
                locationLabel.text = model.location
            } else {
                locationStackView.isHidden = true
            }
            if model.blogURL != nil {
                blogLabel.text = model.blogURL?.absoluteString
            } else {
                blogStackView.isHidden = true
            }
            if model.email != nil {
                emailLabel.text = model.email
            } else {
                emailStackView.isHidden = true
            }
            if model.twitter != nil {
                let atCharacter = "@"
                twitterLabel.text = atCharacter + model.twitter!
            } else {
                twitterStackView.isHidden = true
            }
            followersLabel.text = GitIt.formatPoints(num: Double(model.followers!))
            followingLabel.text = GitIt.formatPoints(num: Double(model.following!))
            settingsButton.isEnabled = true
            shareButton.isEnabled = true
        } else {
            avatarImageView.image = UIImage(systemName: "person")
            fullNameLabel.text = "Guest"
            loginLabel.isHidden = true
            bioLabel.isHidden = true
            companyStackView.isHidden = true
            locationStackView.isHidden = true
            blogStackView.isHidden = true
            emailStackView.isHidden = true
            twitterStackView.isHidden = true
            followStackView.isHidden = true
            settingsButton.isEnabled = true
            shareButton.isEnabled = false
            xTableView.rowHeight = 0.0
        }
    }
    
    // MARK: - View Actions
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        if let model = SessionManager.standard.sessionUser {
            let htmlURL = model.htmlURL
            URLHelper.shareURL(htmlURL)
        }
    }
    
    @objc func saveAvatar(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            UIImageWriteToSavedPhotosAlbum(avatarImageView.image!, self, nil, nil)
        }
    }
    
    @objc func goToBlog() {
        if let model = SessionManager.standard.sessionUser {
            let webURL = model.blogURL
            URLHelper.openURL(webURL!)
        }
    }
    
    @objc func composeMail() {
        if let model = SessionManager.standard.sessionUser {
            let appURL = URL(string: "mailto://" + model.email!)!
            if UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL)
            }
        }
    }
    
    @objc func goToTwitter() {
        if let model = SessionManager.standard.sessionUser {
            let appURL = URL(string: "twitter://user?screen_name=" + model.twitter!)!
            let webURL = URL(string: "https://twitter.com/" + model.twitter!)!
            if UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL)
            } else {
                URLHelper.openURL(webURL)
            }
        }
    }
    
    @objc func showFollowers() {
        if let model = SessionManager.standard.sessionUser {
            let followersVC = UserViewController(context: .followers, contextParameters: (model.login,model.followers))
            navigationController?.pushViewController(followersVC, animated: true)
        }
    }
    
    @objc func showFollowing() {
        if let model = SessionManager.standard.sessionUser {
            let followingVC = UserViewController(context: .following, contextParameters: (model.login,model.following))
            navigationController?.pushViewController(followingVC, animated: true)
        }
    }
    
    func showRepositories() {
        if let model = SessionManager.standard.sessionUser {
            let repositoriesVC = RepositoryViewController(context: .user, contextParameters: (model.login,model.repositories!))
            navigationController?.pushViewController(repositoriesVC, animated: true)
        }
    }
    
    func showOrganizations() {
        if let model = SessionManager.standard.sessionUser {
            let organizationsVC = OrganizationViewController(context: .user, contextParameters: model.login)
            navigationController?.pushViewController(organizationsVC, animated: true)
        }
    }
    
    func showStarred() {
        if let model = SessionManager.standard.sessionUser {
            let repositoriesVC = RepositoryViewController(context: .starred, contextParameters: model.login)
            navigationController?.pushViewController(repositoriesVC, animated: true)
        }
    }
    
    override func showViewController(forRowAt indexPath: IndexPath) {
        super.showViewController(forRowAt: indexPath)
        if indexPath.row == 0 {
            showRepositories()
        } else if indexPath.row == 1 {
            showOrganizations()
        } else if indexPath.row == 2 {
            showStarred()
        }
    }
    
    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        loadHandler(error: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if SessionManager.standard.sessionUser == nil {
            return 0.0
        } else {
            return 60.0
        }
    }

}
