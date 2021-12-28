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
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var avatarImageView: SFImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var homepageImageView: UIImageView!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
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
    
    static func instatiateFromStoryboard(with parameters: Any) -> UIViewController {
        fatalError("This View controller is instaniated only using a model")
    }
    
    static func instatiateFromStoryboard<Type: Model>(with model: Type) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: {coder -> RepositoryDetailViewController in
                        self.init(coder: coder, model: model as! RepositoryModel)!
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
        
        avatarImageView.cornerRadius = 16.0
        avatarImageView.cornerCurve = .continuous
        avatarImageView.masksToBounds = true
        
        let avatarLongPressesGesture = UILongPressGestureRecognizer(target: self, action: #selector(saveAvatar))
        avatarImageView.addGestureRecognizer(avatarLongPressesGesture)
        avatarImageView.isUserInteractionEnabled = true
        
        let loginLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.showOwner))
        loginLabel.addGestureRecognizer(loginLabelTapGesture)
        loginLabel.isUserInteractionEnabled = true
        
        let homepageLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.goToHomepage))
        homepageLabel.addGestureRecognizer(homepageLabelTapGesture)
        homepageLabel.isUserInteractionEnabled = true
        
        let starsLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.showStars))
        starsLabel.addGestureRecognizer(starsLabelTapGesture)
        starsLabel.isUserInteractionEnabled = true
        
        let forksLabelTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.showForks))
        forksLabel.addGestureRecognizer(forksLabelTapGesture)
        forksLabel.isUserInteractionEnabled = true
        
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
        avatarImageView.load(at: model.owner.avatarURL)
        loginLabel.text = model.owner.login
        nameLabel.text = model.name
        if model.description != nil {
            descriptionLabel.text = model.description
        } else {
            descriptionLabel.isHidden = true
        }
        if model.homepageURL != nil {
            homepageLabel.text = model.homepageURL?.absoluteString
        } else {
            homepageLabel.isHidden = true
            homepageImageView.isHidden = true
        }
        starsLabel.text = GitIt.formatPoints(num: Double(model.stars))
        forksLabel.text = GitIt.formatPoints(num: Double(model.forks))
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
    
    @objc func saveAvatar(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            UIImageWriteToSavedPhotosAlbum(avatarImageView.image!, self, nil, nil)
        }
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
            let organizationDetailVC = OrganizationDetailViewController.instatiateFromStoryboard(with: organizationModel)
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
        let licenseVC = LicenseViewController.instatiateFromStoryboard(with: (model.fullName,model.defaultBranch))
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
            starButton.setTitle("Starred", for: .normal)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            starButton.setTitle("Star", for: .normal)
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    private func updateBookmarkButton(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkButton.image = UIImage(systemName: "bookmark")
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
