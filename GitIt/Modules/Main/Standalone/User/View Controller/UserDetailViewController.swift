//
//  UserDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit

class UserDetailViewController: SFStaticTableViewController, StoryboardableViewController {
    
    // MARK: - Properties
    
    static let storyboardIdentifier = "UserDetailVC"
    
    var viewModel: UserDetailViewModel
    
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
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, login: String) {
        viewModel = UserDetailViewModel(withParameter: login)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, collectionCellViewModel: UserCollectionCellViewModel) {
        viewModel = UserDetailViewModel(collectionCellViewModel: collectionCellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, tableCellViewModel: UserTableCellViewModel) {
        viewModel = UserDetailViewModel(tableCellViewModel: tableCellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiate(parameter: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserDetailViewController in
                        self.init(coder: coder, login: parameter)!
                })
    }
    
    static func instatiate<T: CollectionCellViewModel>(collectionCellViewModel: T) -> UIViewController  {
        if let cellViewModel = collectionCellViewModel as? UserCollectionCellViewModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserDetailViewController in
                            self.init(coder: coder, collectionCellViewModel: cellViewModel)!
                    })
        } else {
            return UIViewController()
        }
    }
    
    static func instatiate<T: TableCellViewModel>(tableCellViewModel: T) -> UIViewController  {
        if let cellViewModel = tableCellViewModel as? UserTableCellViewModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserDetailViewController in
                            self.init(coder: coder, tableCellViewModel: cellViewModel)!
                    })
        } else {
            return UIViewController()
        }
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
        
        if NetworkManager.standard.isReachable {
            followButton.isEnabled = true
        } else {
            followButton.isEnabled = false
        }
        
        if SessionManager.standard.sessionType == .guest || viewModel.login == SessionManager.standard.sessionUser?.login  {
            followButton.isHidden = true
        } else {
            followButton.isHidden = false
        }
    }
    
    override func updateView() {
        avatarImageView.load(at: viewModel.avatarURL)
        if viewModel.name != nil {
            fullNameLabel.text = viewModel.name
        } else  {
            fullNameLabel.isHidden = true
        }
        loginLabel.text = viewModel.login
        if viewModel.bio != nil {
            bioLabel.text = viewModel.bio
        } else {
            bioLabel.isHidden = true
        }
        companyTextView.text = viewModel.company
        locationTextView.text = viewModel.location
        blogTextView.text = viewModel.blogURL?.absoluteString
        emailTextView.text = viewModel.email
        twitterTextView.text = viewModel.twitter != nil ? "@".appending(viewModel.twitter!) : nil
        socialStatusNumericView.numbers = [Double(viewModel.followers),Double(viewModel.following)]
        
        updateBookmarkButton()
        updateFollowButton()
        
        bookmarkButton.isEnabled = true
        openInSafariButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func bookmark(_ sender: UIBarButtonItem) {
        viewModel.toggleBookmark(then: updateBookmarkButton)
    }
    
    @IBAction func follow(_ sender: Any) {
        viewModel.toggleFollow(then: updateFollowButton)
    }
    
    @IBAction func openInSafari(_ sender: UIBarButtonItem) {
        URLHelper.openWebsite(viewModel.htmlURL)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        URLHelper.shareWebsite(viewModel.htmlURL)
    }
    
    func goToBlog() {
        URLHelper.openWebsite(viewModel.blogURL!)
    }
    
    func composeMail() {
        URLHelper.openMail(viewModel.email!)
    }
    
    func goToTwitter() {
        URLHelper.openTwitter(viewModel.twitter!)
    }
    
    func showFollowers() {
        let followersVC = UserViewController.instatiate(context: .followers(userLogin: viewModel.login, numberOfFollowers: viewModel.followers) as UserContext)
        NavigationRouter.push(viewController: followersVC)
    }
    
    func showFollowing() {
        let followingVC = UserViewController.instatiate(context: .following(userLogin: viewModel.login, numberOfFollowing: viewModel.following) as UserContext)
        NavigationRouter.push(viewController: followingVC)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController.instatiate(context: .user(userLogin: viewModel.login, numberOfRepositories: viewModel.repositories) as RepositoryContext)
        NavigationRouter.push(viewController: repositoriesVC)
    }
    
    func showOrganizations() {
        let organizationsVC = OrganizationViewController.instatiate(context: .user(userLogin: viewModel.login) as OrganizationContext)
        NavigationRouter.push(viewController: organizationsVC)
    }
    
    func showStarred() {
        let repositoriesVC = RepositoryViewController.instatiate(context: .starred(userLogin: viewModel.login) as RepositoryContext)
        NavigationRouter.push(viewController: repositoriesVC)
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
        viewModel.load(then: loadHandler(error:))
    }
    
}

extension UserDetailViewController {
    
    // MARK: - View Helper Methods (Private)
    
    private func updateFollowButton() {
        if viewModel.isFollowed {
            followButton.setTitle(Constants.View.Button.follow.followedTitle, for: .normal)
            followButton.setImage(Constants.View.Button.follow.followedImage, for: .normal)
        } else {
            followButton.setTitle(Constants.View.Button.follow.defaultTitle, for: .normal)
            followButton.setImage(Constants.View.Button.follow.defaultImage, for: .normal)
        }
    }
    
    private func updateBookmarkButton() {
        if viewModel.isBookmarked {
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
            let actionProvider = ImageActionProvider(saveImage: { UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) })
            return ContextMenuConfigurationConstants.SaveImageConfiguration(with: actionProvider)
        }
        return nil
    }
    
}

struct ImageActionProvider {
    
    var saveImage: () -> Void
    
}
