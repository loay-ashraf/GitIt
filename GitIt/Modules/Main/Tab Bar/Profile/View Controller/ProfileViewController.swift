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
    @IBOutlet weak var avatarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var companyTextView: IconicTextView!
    @IBOutlet weak var locationTextView: IconicTextView!
    @IBOutlet weak var blogTextView: IconicTextView!
    @IBOutlet weak var emailTextView: IconicTextView!
    @IBOutlet weak var twitterTextView: IconicTextView!
    @IBOutlet weak var socialStatusNumericView: IconicNumericView!
    @IBOutlet weak var signInButton: UIButton!
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
        
        NavigayionBarConstants.configureAppearance(for: navigationController?.navigationBar)
        navigationItem.largeTitleDisplayMode = .never
        
        if SessionManager.standard.sessionType == .authenticated, SessionManager.standard.sessionUser != nil {
            avatarImageView.cornerRadius = 64.0
            avatarImageView.cornerCurve = .continuous
            avatarImageView.masksToBounds = true
            
            avatarImageView.addInteraction(UIContextMenuInteraction(delegate: self))
            
            blogTextView.action = { [weak self] in self?.goToBlog() }
            emailTextView.action = { [weak self] in self?.composeMail() }
            twitterTextView.action = { [weak self] in self?.goToTwitter() }
            socialStatusNumericView.actions = [{ [weak self] in self?.showFollowers() },{ [weak self] in self?.showFollowing() }]
            
            signInButton.isHidden = true
        } else {
            avatarImageView.cornerRadius = 0.0
            avatarHeightConstraint.constant = 64.0
            avatarWidthConstraint.constant = 64.0
            
            avatarImageView.image = Constants.View.Image.guest
            fullNameLabel.text = Constants.View.Label.guest
            loginLabel.isHidden = true
            bioLabel.text = Constants.View.Label.signIn
            companyTextView.isHidden = true
            locationTextView.isHidden = true
            blogTextView.isHidden = true
            emailTextView.isHidden = true
            twitterTextView.isHidden = true
            socialStatusNumericView.isHidden = true
            
            signInButton.isHidden = false
            signInButton.cornerRadius = 10.0
            signInButton.cornerCurve = .continuous
            signInButton.masksToBounds = true
            settingsButton.isEnabled = true
            shareButton.isEnabled = false
        }
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
            companyTextView.text = model.company
            locationTextView.text = model.location
            blogTextView.text = model.blogURL?.absoluteString
            emailTextView.text = model.email
            twitterTextView.text = model.twitter != nil ? "@".appending(model.twitter!) : nil
            socialStatusNumericView.numbers = [Double(model.followers!),Double(model.following!)]
        }
    }
    
    // MARK: - View Actions
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        if let model = SessionManager.standard.sessionUser {
            let htmlURL = model.htmlURL
            URLHelper.shareWebsite(htmlURL)
        }
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        SessionManager.standard.signOut()
        performSegue(withIdentifier: "unwindToSplash", sender: self)
    }
    
    func goToBlog() {
        if let model = SessionManager.standard.sessionUser {
            let webURL = model.blogURL
            URLHelper.openWebsite(webURL!)
        }
    }
    
    func composeMail() {
        if let model = SessionManager.standard.sessionUser {
            let appURL = URL(string: "mailto://" + model.email!)!
            if UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL)
            }
        }
    }
    
    func goToTwitter() {
        if let model = SessionManager.standard.sessionUser {
            URLHelper.openTwitter(model.twitter!)
        }
    }
    
    func showFollowers() {
        if let model = SessionManager.standard.sessionUser {
            let followersVC = UserViewController.instatiate(context: .followers(userLogin: model.login, numberOfFollowers: model.followers!) as UserContext)
            navigationController?.pushViewController(followersVC, animated: true)
        }
    }
    
    func showFollowing() {
        if let model = SessionManager.standard.sessionUser {
            let followingVC = UserViewController.instatiate(context: .following(userLogin: model.login, numberOfFollowing: model.following!) as UserContext)
            navigationController?.pushViewController(followingVC, animated: true)
        }
    }
    
    func showRepositories() {
        if let model = SessionManager.standard.sessionUser {
            let repositoriesVC = RepositoryViewController.instatiate(context: .user(userLogin: model.login, numberOfRepositories: model.repositories!) as RepositoryContext)
            navigationController?.pushViewController(repositoriesVC, animated: true)
        }
    }
    
    func showOrganizations() {
        if let model = SessionManager.standard.sessionUser {
            let organizationsVC = OrganizationViewController.instatiate(context: .user(userLogin: model.login) as OrganizationContext)
            navigationController?.pushViewController(organizationsVC, animated: true)
        }
    }
    
    func showStarred() {
        if let model = SessionManager.standard.sessionUser {
            let repositoriesVC = RepositoryViewController.instatiate(context: .starred(userLogin: model.login) as RepositoryContext)
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
        if SessionManager.standard.sessionType == .guest || SessionManager.standard.sessionUser == nil {
            return 0.0
        } else {
            return 60.0
        }
    }

}

extension ProfileViewController: UIContextMenuInteractionDelegate {
    
    // MARK: - Context Menu Delegate
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        if let image = avatarImageView.image {
            let actionProvider = ImageActionProvider(saveImage: { UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) })
            return ContextMenuConfigurationConstants.SaveImageConfiguration(with: actionProvider)
        } else {
            return UIContextMenuConfiguration()
        }
    }
    
}
