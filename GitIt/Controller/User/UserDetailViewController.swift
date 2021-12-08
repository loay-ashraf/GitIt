//
//  UserDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit
import CoreData

class UserDetailViewController: UITableViewController, DetailViewController {

    static let identifier = "UserDetailVC"
    
    private var logicController: UserDetailLogicController
    private var model: UserModel { return logicController.model }
    private var isBookmarked: Bool { return logicController.isBookmarked }
    private var isFollowed: Bool { return logicController.isFollowed }
    
    private var spinner: Spinner!
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var avatarImageView: AsynchronousUIImageView!
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
    
    init?(coder: NSCoder, model: UserModel) {
        logicController = UserDetailLogicController(model)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiateFromStoryBoard<Type: Model>(with model: Type) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: UserDetailViewController.identifier, creator: {coder ->                                  UserDetailViewController in
                 UserDetailViewController(coder: coder, model: model as! UserModel)!
                })
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        render(.loading)
        logicController.load(then: render(_:))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fitTableHeaderView()
    }
    
    // MARK: - UI Actions
    
    @IBAction func follow(_ sender: Any) {
        logicController.follow(then: render(_:))
    }
    
    @IBAction func bookmark(_ sender: Any) {
        logicController.bookmark(then: render(_:))
    }
    
    @IBAction func share(_ sender: Any) {
        GitIt.share(model.htmlURL)
    }
    
    @objc func saveAvatar(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            UIImageWriteToSavedPhotosAlbum(avatarImageView.image!, self, nil, nil)
        }
    }
    
    @objc func goToBlog() {
        var urlComponents = URLComponents(url: model.blogURL!, resolvingAgainstBaseURL: false)
        if urlComponents?.scheme == nil { urlComponents?.scheme = "https" }
        let webURL = urlComponents?.url
        GitIt.openURL(webURL!)
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
            GitIt.openURL(webURL)
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
    
    func showStarred() {
        let repositoriesVC = RepositoryViewController(context: .starred, contextParameters: model.login)
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
}

extension UserDetailViewController {
    
    // MARK: - UI Helper Methods
    
    func render(_ state: UserDetailViewState) {
        switch state {
        case .loading: showSpinner()
        case .followed: updateFollowButton()
        case .bookmarked: updateBookmarkButton()
        case .presenting: hideSpinner()
                          updateUI()
        case .failed(let error): print(error)
        }
    }
    
    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        
        spinner = Spinner(self)
        
        avatarImageView.cornerRadius = 64.0
        avatarImageView.cornerCurve = .continuous
        avatarImageView.masksToBounds = true
        
        let avatarLongPressesGesture = UILongPressGestureRecognizer(target: self, action: #selector(saveAvatar))
        avatarImageView.addGestureRecognizer(avatarLongPressesGesture)
        avatarImageView.isUserInteractionEnabled = true
        
        let blogLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.goToBlog))
        blogLabel.addGestureRecognizer(blogLabelTapGesture)
        blogLabel.isUserInteractionEnabled = true
        
        let emailLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.composeMail))
        emailLabel.addGestureRecognizer(emailLabelTapGesture)
        emailLabel.isUserInteractionEnabled = true
        
        let twitterLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.goToTwitter))
        twitterLabel.addGestureRecognizer(twitterLabelTapGesture)
        twitterLabel.isUserInteractionEnabled = true
        
        let followersLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.showFollowers))
        followersLabel.addGestureRecognizer(followersLabelTapGesture)
        followersLabel.isUserInteractionEnabled = true
        
        let followingLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.showFollowing))
        followingLabel.addGestureRecognizer(followingLabelTapGesture)
        followingLabel.isUserInteractionEnabled = true
        
        followButton.cornerRadius = 10
        followButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    }
    
    private func updateUI() {
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
            shareButton.isEnabled = true
        } else {
            bookmarkButton.isEnabled = true
            shareButton.isEnabled = true
            updateFollowButton()
            updateBookmarkButton()
        }
    }
    
    private func fitTableHeaderView() {
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
    
    private func showSpinner() {
        spinner.showMainSpinner()
    }
    
    private func hideSpinner() {
        spinner.hideMainSpinner()
    }
    
    private func updateFollowButton() {
        if isFollowed {
            followButton.setTitle("Following", for: .normal)
            followButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
    
    private func updateBookmarkButton() {
        if isBookmarked {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkButton.image = UIImage(systemName: "bookmark")
        }
    }
    
}

extension UserDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            showRepositories()
        } else if indexPath.row == 2 {
            showStarred()
        }
    }

}
