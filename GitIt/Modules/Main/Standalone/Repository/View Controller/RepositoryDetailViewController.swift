//
//  RepositoryDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit
import MarkdownView

class RepositoryDetailViewController: WSSFStaticTableViewController, StoryboardableViewController {
    
    // MARK: - Properties
    
    static let storyboardIdentifier = "RepositoryDetailVC"
    
    var viewModel: RepositoryDetailViewModel
    
    // MARK: - View Outlets
    
    @IBOutlet weak var ownerTextView: IconicTextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var homepageTextView: IconicTextView!
    @IBOutlet weak var starsNumericView: IconicNumericView!
    @IBOutlet weak var forksNumericView: IconicNumericView!
    @IBOutlet weak var READMEStackView: UIStackView!
    @IBOutlet weak var defaultBranchLabel: UILabel!
    @IBOutlet weak var READMEView: MarkdownView!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var openInSafariButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, fullName: String) {
        viewModel = RepositoryDetailViewModel(withParameter: fullName)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, collectionCellViewModel: RepositoryCollectionCellViewModel) {
        viewModel = RepositoryDetailViewModel(collectionCellViewModel: collectionCellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, tableCellViewModel: RepositoryTableCellViewModel) {
        viewModel = RepositoryDetailViewModel(tableCellViewModel: tableCellViewModel)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }

    static func instatiate(parameter: String) -> UIViewController {
        let storyBoard = StoryboardConstants.main
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> RepositoryDetailViewController in
                        self.init(coder: coder, fullName: parameter)!
                })
    }
    
    static func instatiate<T: CollectionCellViewModel>(collectionCellViewModel: T) -> UIViewController  {
        if let cellViewModel = collectionCellViewModel as? RepositoryCollectionCellViewModel {
            let storyBoard = StoryboardConstants.main
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> RepositoryDetailViewController in
                            self.init(coder: coder, collectionCellViewModel: cellViewModel)!
                    })
        } else {
            return UIViewController()
        }
    }
    
    static func instatiate<T: TableCellViewModel>(tableCellViewModel: T) -> UIViewController  {
        if let cellViewModel = tableCellViewModel as? RepositoryTableCellViewModel {
            let storyBoard = StoryboardConstants.main
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> RepositoryDetailViewController in
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
        
        ownerTextView.action = { [weak self] in self?.showOwner() }
        homepageTextView.action = { [weak self] in self?.goToHomepage() }
        starsNumericView.actions = [ { [weak self] in self?.showStars() } ]
        forksNumericView.actions = [ { [weak self] in self?.showForks() } ]
        
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .leftToRight: starButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15.0)
        case .rightToLeft: starButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        @unknown default: break
        }
        
        if NetworkManager.standard.isReachable {
            starButton.isEnabled = true
        } else {
            starButton.isEnabled = false
        }
        
        if SessionManager.standard.sessionType == .guest  {
            starButton.isHidden = true
        } else {
            starButton.isHidden = false
        }
        
        READMEView.isScrollEnabled = false
        READMEView.onTouchLink = { request in
            guard let url = request.url else { return false }
            URLHelper.openWebsite(url)
            return false
        }
    }
    
    override func updateView() {
        ownerTextView.text = viewModel.owner.login
        ownerTextView.loadIcon(at: viewModel.owner.avatarURL)
        nameLabel.text = viewModel.name
        if viewModel.description != nil {
            descriptionLabel.text = viewModel.description
        } else {
            descriptionLabel.isHidden = true
        }
        homepageTextView.text = viewModel.homepageURL?.absoluteString
        starsNumericView.numbers = [Double(viewModel.stars)]
        forksNumericView.numbers = [Double(viewModel.forks)]
        
        xTableView.beginUpdates()
        xTableView.endUpdates()
        
        updateReadmeView()
        Task {
            let status = await viewModel.checkForStatus()
            updateBookmarkButton(isBookmarked: status[0])
            updateStarButton(isStarred: status[1])
        }
        
        bookmarkButton.isEnabled = true
        openInSafariButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func bookmark(_ sender: UIBarButtonItem) {
        updateBookmarkButton(isBookmarked: viewModel.toggleBookmark())
    }
    
    @IBAction func star(_ sender: UIButton) {
        Task {
            updateStarButton(isStarred: await viewModel.toggleStar())
        }
    }
    
    @IBAction func openInSafari(_ sender: UIBarButtonItem) {
        URLHelper.openWebsite(viewModel.htmlURL)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        URLHelper.shareWebsite(viewModel.htmlURL)
    }
    
    func showOwner() {
        if viewModel.owner.type == .user {
            let userLogin = viewModel.owner.login
            let userDetailVC = UserDetailViewController.instatiate(parameter: userLogin)
            NavigationRouter.push(viewController: userDetailVC)
        } else if viewModel.owner.type == .organization {
            let organizationLogin = viewModel.owner.login
            let organizationDetailVC = OrganizationDetailViewController.instatiate(parameter: organizationLogin)
            NavigationRouter.push(viewController: organizationDetailVC)
        }
    }
    
    func goToHomepage() {
        URLHelper.openWebsite(viewModel.homepageURL!)
    }
    
    func showStars() {
        let starsVC = UserViewController.instatiate(context: .stargazers(repositoryFullName: viewModel.fullName, numberOfStargazers: viewModel.stars) as UserContext)
        NavigationRouter.push(viewController: starsVC)
    }
    
    func showForks() {
        let forksVC = RepositoryViewController.instatiate(context: .forks(repositoryFullName: viewModel.fullName, numberOfForks: viewModel.forks) as RepositoryContext)
        NavigationRouter.push(viewController: forksVC)
    }
    
    func showContributors() {
        let contributorsVC = UserViewController.instatiate(context: .contributors(repositoryFullName: viewModel.fullName) as UserContext)
        NavigationRouter.push(viewController: contributorsVC)
    }
    
    func showCommits() {
        let commitsVC = CommitViewController.instatiate(parameter: viewModel.fullName)
        NavigationRouter.push(viewController: commitsVC)
    }
    
    func showLicense() {
        let licenseVC = LicenseViewController.instatiate(parameters: [viewModel.fullName,viewModel.defaultBranch])
        NavigationRouter.push(viewController: licenseVC)
    }
    
    override func showViewController(forRowAt indexPath: IndexPath) {
        super.showViewController(forRowAt: indexPath)
        if indexPath.row == 0 {
            showContributors()
        } else if indexPath.row == 1 {
            showCommits()
        } else if indexPath.row == 2 {
            showLicense()
        }
    }
    
    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        Task {
            loadHandler(error: await viewModel.load())
        }
    }
    
}

extension RepositoryDetailViewController {
    
    // MARK: - View Helper Methods (Private)
    
    private func updateBookmarkButton(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.image = Constants.View.Button.bookmark.bookmarkedImage
        } else {
            bookmarkButton.image = Constants.View.Button.bookmark.defaultImage
        }
    }
    
    private func updateStarButton(isStarred: Bool) {
        if isStarred {
            starButton.setTitle(Constants.View.Button.star.starredTitle, for: .normal)
            starButton.setImage(Constants.View.Button.star.starredImage, for: .normal)
        } else {
            starButton.setTitle(Constants.View.Button.star.defaultTitle, for: .normal)
            starButton.setImage(Constants.View.Button.star.defaultImage, for: .normal)
        }
    }
    
    private func updateReadmeView() {
        if let READMEString = viewModel.READMEString {
            defaultBranchLabel.text = viewModel.defaultBranch
            READMEView.load(markdown: READMEString)
        } else {
            tableView.tableFooterView = nil
        }
        fitTableFooterView()
    }
    
}

extension RepositoryDetailViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.license == nil && indexPath.row == 2 {
            return 0.0
        }
        return 60.0
    }
    
}
