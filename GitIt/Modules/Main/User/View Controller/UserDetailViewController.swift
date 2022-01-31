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
    @IBOutlet weak var companyTextView: IconicTextView!
    @IBOutlet weak var locationTextView: IconicTextView!
    @IBOutlet weak var blogTextView: IconicTextView!
    @IBOutlet weak var emailTextView: IconicTextView!
    @IBOutlet weak var twitterTextView: IconicTextView!
    @IBOutlet weak var socialStatusNumericView: IconicNumericView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var openInSafariButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, model: UserModel) {
        logicController = UserDetailLogicController(model)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiateWithParameters(with parameters: Any) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using a model")
    }
    
    static func instatiateWithModel(with model: Any) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: {coder -> UserDetailViewController in
                    self.init(coder: coder, model: model as! UserModel)!
                })
    }
    
    deinit {
        debugPrint(String(describing: self) + " deallocated")
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
        
        avatarImageView.addInteraction(UIContextMenuInteraction(delegate: self))
        
        blogTextView.action = { [weak self] in self?.goToBlog() }
        emailTextView.action = { [weak self] in self?.composeMail() }
        twitterTextView.action = { [weak self] in self?.goToTwitter() }
        socialStatusNumericView.actions = [{ [weak self] in self?.showFollowers() },{ [weak self] in self?.showFollowing() }]
        
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .leftToRight: followButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15.0)
        case .rightToLeft: followButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        @unknown default: break
        }
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
        companyTextView.text = model.company
        locationTextView.text = model.location
        blogTextView.text = model.blogURL?.absoluteString
        emailTextView.text = model.email
        twitterTextView.text = model.twitter != nil ? "@".appending(model.twitter!) : nil
        if let followers = model.followers, let following = model.following {
            socialStatusNumericView.numbers = [Double(followers),Double(following)]
        }
        
        if NetworkManager.standard.isReachable {
            followButton.isEnabled = true
        } else {
            followButton.isEnabled = false
        }
        
        if SessionManager.standard.sessionType == .guest || model.login == SessionManager.standard.sessionUser?.login  {
            followButton.isHidden = true
        } else {
            followButton.isHidden = false
        }
        
        bookmarkButton.isEnabled = true
        openInSafariButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func follow(_ sender: Any) {
        logicController.follow(then: updateFollowButton(isFollowed:))
    }
    
    @IBAction func bookmark(_ sender: UIBarButtonItem) {
        logicController.bookmark(then: updateBookmarkButton(isBookmarked:))
    }
    
    @IBAction func openInSafari(_ sender: UIBarButtonItem) {
        let htmlURL = model.htmlURL
        URLHelper.openURL(htmlURL)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        let htmlURL = model.htmlURL
        URLHelper.shareURL(htmlURL)
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
        let followersVC = UserViewController.instatiateWithContext(with: .followers(userLogin: model.login, numberOfFollowers: model.followers!))
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    @objc func showFollowing() {
        let followingVC = UserViewController.instatiateWithContext(with: .following(userLogin: model.login, numberOfFollowing: model.following!))
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController.instatiateWithContext(with: .user(userLogin: model.login, numberOfRepositories: model.repositories!))
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
    func showOrganizations() {
        let organizationsVC = OrganizationViewController.instatiateWithContext(with: .user(userLogin: model.login))
        navigationController?.pushViewController(organizationsVC, animated: true)
    }
    
    func showStarred() {
        let repositoriesVC = RepositoryViewController.instatiateWithContext(with: .starred(userLogin: model.login))
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
    
    // MARK: - View Helper Methods (Private)
    
    private func updateFollowButton(isFollowed: Bool) {
        if isFollowed {
            followButton.setTitle(Constants.View.Button.follow.followedTitle, for: .normal)
            followButton.setImage(Constants.View.Button.follow.followedImage, for: .normal)
        } else {
            followButton.setTitle(Constants.View.Button.follow.defaultTitle, for: .normal)
            followButton.setImage(Constants.View.Button.follow.defaultImage, for: .normal)
        }
    }
    
    private func updateBookmarkButton(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.image = Constants.View.Button.bookmark.bookmarkedImage
        } else {
            bookmarkButton.image = Constants.View.Button.bookmark.defaultImage
        }
    }
    
}

extension UserDetailViewController: UIContextMenuInteractionDelegate {
    
    // MARK: - Context Menu Delegate
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        if let image = avatarImageView.image {
            return ContextMenuConfigurationConstants.SaveImageConfiguration(for: image)
        } else {
            return UIContextMenuConfiguration()
        }
    }
    
}
