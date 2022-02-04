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
        viewModel = UserDetailViewModel(login: login)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, cellViewModel: UserCellViewModel) {
        viewModel = UserDetailViewModel(cellViewModel: cellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, model: UserModel) {
        viewModel = UserDetailViewModel(model: model)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiate<T: ViewControllerContext>(context: T) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using paramter, cellViewModel or model")
    }
    
    static func instatiate(parameter: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserDetailViewController in
                        self.init(coder: coder, login: parameter)!
                })
    }
    
    static func instatiate<T: CellViewModel>(cellViewModel: T) -> UIViewController  {
        if let cellViewModel = cellViewModel as? UserCellViewModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserDetailViewController in
                            self.init(coder: coder, cellViewModel: cellViewModel)!
                    })
        } else {
            return UIViewController()
        }
    }
    
    static func instatiate<T: Model>(model: T) -> UIViewController  {
        if let model = model as? UserModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> UserDetailViewController in
                            self.init(coder: coder, model: model)!
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
        
        blogTextView.action = { [weak self] in self?.viewModel.goToBlog() }
        emailTextView.action = { [weak self] in self?.viewModel.composeMail() }
        twitterTextView.action = { [weak self] in self?.viewModel.goToTwitter() }
        socialStatusNumericView.actions = [{ [weak self] in self?.viewModel.showFollowers(navigationController: self?.navigationController) },{ [weak self] in self?.viewModel.showFollowing(navigationController: self?.navigationController) }]
        
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
        viewModel.bookmarkAction(then: updateBookmarkButton)
    }
    
    @IBAction func follow(_ sender: Any) {
        viewModel.followAction(then: updateFollowButton)
    }
    
    @IBAction func openInSafari(_ sender: UIBarButtonItem) {
        viewModel.openInSafari()
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        viewModel.share()
    }
    
    override func showViewController(forRowAt indexPath: IndexPath) {
        super.showViewController(forRowAt: indexPath)
        if indexPath.row == 0 {
            viewModel.showRepositories(navigationController: navigationController)
        } else if indexPath.row == 1 {
            viewModel.showOrganizations(navigationController: navigationController)
        } else if indexPath.row == 2 {
            viewModel.showStarred(navigationController: navigationController)
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
            return ContextMenuConfigurationConstants.SaveImageConfiguration(for: image)
        } else {
            return UIContextMenuConfiguration()
        }
    }
    
}
