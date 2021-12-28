//
//  UserDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class UserDetailViewController: SFStaticTableViewController, IBViewController {
    
    static let storyboardIdentifier = "UserDetailVC"
    
    private let logicController: UserDetailLogicController
    private var model: UserModel { return logicController.model }
    
    // MARK: - View Outlets
    
    @IBOutlet weak var avatarImageView: SFImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var blogImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var twitterImageView: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, model: UserModel) {
        logicController = UserDetailLogicController(model)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiateFromStoryboard(with parameters: Any) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using a model")
    }
    
    static func instatiateFromStoryboard<Type: Model>(with model: Type) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: {coder -> UserDetailViewController in
                    self.init(coder: coder, model: model as! UserModel)!
                })
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        
        navigationItem.largeTitleDisplayMode = .never
        
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
        
        followButton.cornerRadius = 10
    }
    
    override func updateView() {
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
            companyImageView.isHidden = true
            companyLabel.isHidden = true
        }
        if model.location != nil {
            locationLabel.text = model.location
        } else {
            locationImageView.isHidden = true
            locationLabel.isHidden = true
        }
        if model.blogURL != nil {
            blogLabel.text = model.blogURL?.absoluteString
        } else {
            blogImageView.isHidden = true
            blogLabel.isHidden = true
        }
        if model.email != nil {
            emailLabel.text = model.email
        } else {
            emailImageView.isHidden = true
            emailLabel.isHidden = true
        }
        if model.twitter != nil {
            let atCharacter = "@"
            twitterLabel.text = atCharacter + model.twitter!
        } else {
            twitterImageView.isHidden = true
            twitterLabel.isHidden = true
        }
        followersLabel.text = GitIt.formatPoints(num: Double(model.followers!))
        followingLabel.text = GitIt.formatPoints(num: Double(model.following!))
        if model.login == SessionManager.standard.sessionUser.login {
            followButton.isHidden = true
        } else {
            bookmarkButton.isEnabled = true
        }
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func follow(_ sender: Any) {
        logicController.follow(then: updateFollowButton(isFollowed:))
    }
    
    @IBAction func bookmark(_ sender: Any) {
        logicController.bookmark(then: updateBookmarkButton(isBookmarked:))
    }
    
    @IBAction func share(_ sender: Any) {
        let htmlURL = model.htmlURL
        URLHelper.shareURL(htmlURL)
    }
    
    @objc func saveAvatar(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            UIImageWriteToSavedPhotosAlbum(avatarImageView.image!, self, nil, nil)
        }
    }
    
    @objc func goToBlog() {
        let webURL = model.blogURL
        URLHelper.openURL(webURL!)
    }
    
    @objc func composeMail() {
        let appURL = URL(string: "mailto://" + model.email!)!
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        }
    }
    
    @objc func goToTwitter() {
        let appURL = URL(string: "twitter://user?screen_name=" + model.twitter!)!
        let webURL = URL(string: "https://twitter.com/" + model.twitter!)!
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            URLHelper.openURL(webURL)
        }
    }
    
    @objc func showFollowers() {
        let followersVC = UserViewController(context: .followers, contextParameters: (self.model.login,self.model.followers))
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    @objc func showFollowing() {
        let followingVC = UserViewController(context: .following, contextParameters: (self.model.login,self.model.following))
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController(context: .user, contextParameters: (model.login,model.repositories!))
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
    func showOrganizations() {
        let organizationsVC = OrganizationViewController(context: .user, contextParameters: model.login)
        navigationController?.pushViewController(organizationsVC, animated: true)
    }
    
    func showStarred() {
        let repositoriesVC = RepositoryViewController(context: .starred, contextParameters: model.login)
        navigationController?.pushViewController(repositoriesVC, animated: true)
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
        logicController.load(then: loadHandler(error:), then: updateFollowButton(isFollowed:), then: updateBookmarkButton(isBookmarked:))
    }
    
}

extension UserDetailViewController {
    
    // View Helper Methods (Private)
    
    private func updateFollowButton(isFollowed: Bool) {
        if isFollowed {
            followButton.setTitle("Following", for: .normal)
            followButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    private func updateBookmarkButton(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkButton.image = UIImage(systemName: "bookmark")
        }
    }
    
}
