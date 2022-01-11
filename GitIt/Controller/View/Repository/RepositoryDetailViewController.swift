//
//  RepositoryDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit
import MarkdownView

class RepositoryDetailViewController: SFStaticTableViewController, IBViewController {
    
    static let storyboardIdentifier = "RepositoryDetailVC"
    
    private var logicController: RepositoryDetailLogicController
    private var model: RepositoryModel { return logicController.model }
    
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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, model: RepositoryModel) {
        logicController = RepositoryDetailLogicController(model)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiateWithParameters(with parameters: Any) -> UIViewController {
        fatalError("This View controller is instaniated only using a model")
    }
    
    static func instatiateWithModel(with model: Any) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: {coder -> RepositoryDetailViewController in
                        self.init(coder: coder, model: model as! RepositoryModel)!
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
        
        ownerTextView.action = { [weak self] in self?.showOwner() }
        homepageTextView.action = { [weak self] in self?.goToHomepage() }
        starsNumericView.actions = [ { [weak self] in self?.showStars() } ]
        forksNumericView.actions = [ { [weak self] in self?.showForks() } ]
        
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .leftToRight: starButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15.0)
        case .rightToLeft: starButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        @unknown default: break
        }
        starButton.cornerRadius = 10
        
        READMEView.isScrollEnabled = false
        READMEView.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            if url.scheme == "https" || url.scheme == "http"  {
                URLHelper.openURL(url)
                return false
            } else { return false }
        }
    }
    
    override func updateView() {
        ownerTextView.text = model.owner.login
        ownerTextView.loadImage(at: model.owner.avatarURL)
        nameLabel.text = model.name
        if model.description != nil {
            descriptionLabel.text = model.description
        } else {
            descriptionLabel.isHidden = true
        }
        homepageTextView.text = model.homepageURL?.absoluteString
        starsNumericView.numbers = [Double(model.stars)]
        forksNumericView.numbers = [Double(model.forks)]
        bookmarkButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func star(_ sender: Any) {
        logicController.star(then: updateStarButton(isStarred:))
    }
    
    @IBAction func bookmark(_ sender: Any) {
        logicController.bookmark(then: updateBookmarkButton(isBookmarked:))
    }
    
    @IBAction func share(_ sender: Any) {
        let htmlURL = model.htmlURL
        URLHelper.shareURL(htmlURL)
    }
    
    @objc func showOwner() {
        if model.owner.type == .user {
            let userModel = UserModel(from: model.owner)
            let userDetailVC = storyboard?.instantiateViewController(identifier: "UserDetailVC", creator: {coder -> UserDetailViewController in
                UserDetailViewController(coder: coder, model: userModel)!
            })
            navigationController?.pushViewController(userDetailVC!, animated: true)
        } else if model.owner.type == .organization {
            let organizationModel = OrganizationModel(from: model.owner)
            let organizationDetailVC = OrganizationDetailViewController.instatiateWithModel(with: organizationModel)
            navigationController?.pushViewController(organizationDetailVC, animated: true)
        }
    }
    
    @objc func goToHomepage() {
        let webURL = model.homepageURL
        URLHelper.openURL(webURL!)
    }
    
    @objc func showStars() {
        let starsVC = UserViewController(context: .stars, contextParameters: (model.fullName,model.stars))
        navigationController?.pushViewController(starsVC, animated: true)
    }
    
    @objc func showForks() {
        let forksVC = RepositoryViewController(context: .forks, contextParameters: (model.fullName,model.forks))
        navigationController?.pushViewController(forksVC, animated: true)
    }
    
    func showContributors() {
        let contributorsVC = UserViewController(context: .contributors, contextParameters: model.fullName)
        navigationController?.pushViewController(contributorsVC, animated: true)
    }
    
    func showCommits() {
        let commitsVC = CommitViewController(parameters: model.fullName)
        navigationController?.pushViewController(commitsVC, animated: true)
    }
    
    func showLicense() {
        let licenseVC = LicenseViewController.instatiateWithParameters(with: (model.fullName,model.defaultBranch))
        navigationController?.pushViewController(licenseVC, animated: true)
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
        logicController.load(then: loadHandler(error:), then: updateStarButton(isStarred:), then: updateBookmarkButton(isBookmarked:), then: updateReadmeView(networkError:))
    }
    
}

extension RepositoryDetailViewController {
    
    // MARK: - View Actions (private)
    
    private func updateStarButton(isStarred: Bool) {
        if isStarred {
            starButton.setTitle(Constants.view.button.star.starredTitle, for: .normal)
            starButton.setImage(Constants.view.button.star.starredImage, for: .normal)
        } else {
            starButton.setTitle(Constants.view.button.star.defaultTitle, for: .normal)
            starButton.setImage(Constants.view.button.star.defaultImage, for: .normal)
        }
    }
    
    private func updateBookmarkButton(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.image = Constants.view.button.bookmark.bookmarkedImage
        } else {
            bookmarkButton.image = Constants.view.button.bookmark.defaultImage
        }
    }
    
    private func updateReadmeView(networkError: NetworkError?) {
        if networkError != nil {
            tableView.tableFooterView = nil
        } else {
            defaultBranchLabel.text = model.defaultBranch
            READMEView.load(markdown: model.READMEString)
        }
        fitTableFooterView()
    }
    
}
