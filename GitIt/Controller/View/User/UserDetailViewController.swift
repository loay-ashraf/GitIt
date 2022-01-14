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
        print("Controller deallocated")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if subViewsOffsetSize != .searchScreenWithNavBar {
            subViewsOffsetSize = .mainScreenWithSearch
        } else {
            subViewsOffsetSize = .searchScreen
        }
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
        socialStatusNumericView.numbers = [Double(model.followers!),Double(model.following!)]
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
    
    @IBAction func saveAvatar(_ sender: UILongPressGestureRecognizer) {
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
        let followersVC = UserViewController.instatiateWithContextAndParameters(with: .followers, with: (self.model.login,self.model.followers))
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    @objc func showFollowing() {
        let followingVC = UserViewController.instatiateWithContextAndParameters(with: .following, with: (self.model.login,self.model.following))
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController.instatiateWithContextAndParameters(with: .user, with: (model.login,model.repositories!))
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
    func showOrganizations() {
        let organizationsVC = OrganizationViewController.instatiateWithContextAndParameters(with: .user, with: model.login)
        navigationController?.pushViewController(organizationsVC, animated: true)
    }
    
    func showStarred() {
        let repositoriesVC = RepositoryViewController.instatiateWithContextAndParameters(with: .starred, with: model.login)
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
            followButton.setTitle(Constants.View.button.follow.followedTitle, for: .normal)
            followButton.setImage(Constants.View.button.follow.followedImage, for: .normal)
        } else {
            followButton.setTitle(Constants.View.button.follow.defaultTitle, for: .normal)
            followButton.setImage(Constants.View.button.follow.defaultImage, for: .normal)
        }
    }
    
    private func updateBookmarkButton(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.image = Constants.View.button.bookmark.bookmarkedImage
        } else {
            bookmarkButton.image = Constants.View.button.bookmark.defaultImage
        }
    }
    
}
