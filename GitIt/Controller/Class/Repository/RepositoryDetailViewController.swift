//
//  RepositoryDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit
import MarkdownView

class RepositoryDetailViewController: UITableViewController, StoryboardViewController {
    
    static let storyboardIdentifier = "RepositoryDetailVC"
    
    private var logicController: RepositoryDetailLogicController
    private var model: RepositoryModel { return logicController.model }
    private var isBookmarked: Bool { return logicController.isBookmarked }
    private var isStarred: Bool { return logicController.isStarred }
    
    private var spinner: Spinner!
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var avatarImageView: AsyncUIImageView!
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
        configureUI()
        render(.loading)
        logicController.load(then: render(_:))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fitTableHeaderView()
        fitTableFooterView()
    }
    
    // MARK: - UI Actions
    
    @IBAction func star(_ sender: Any) {
        logicController.star(then: render(_:))
    }
    
    @IBAction func bookmark(_ sender: Any) {
        logicController.bookmark(then: render(_:))
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
    
}

extension RepositoryDetailViewController {
    
    // MARK: - UI Helper Methods
    
    func render(_ state: RepositoryDetailViewState) {
        switch state {
        case .loading: showSpinner()
        case .starred: updateStarButton()
        case .bookmarked: updateBookmarkButton()
        case .presenting: hideSpinner()
                          updateUI()
        case .failed(let error): print(error)
        }
    }
    
    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        
        spinner = Spinner(self)
        
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
        
        READMEView.isScrollEnabled = false
        READMEView.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            if url.scheme == "https" || url.scheme == "http"  {
                URLHelper.openURL(url)
                return false
            } else { return false }
        }
        
        starButton.cornerRadius = 10
    }
    
    private func updateUI() {
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
        if model.READMEString != nil {
            defaultBranchLabel.text = model.defaultBranch
            READMEView.load(markdown: model.READMEString)
        } else {
            READMEStackView.isHidden = true
        }
        bookmarkButton.isEnabled = true
        shareButton.isEnabled = true
        updateStarButton()
        updateBookmarkButton()
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
    
    private func fitTableFooterView() {
        guard let footerView = tableView.tableFooterView else {
            return
        }
        let size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
            tableView.tableFooterView = footerView
            tableView.layoutIfNeeded()
        }
    }
    
    private func showSpinner() {
        spinner.showMainSpinner()
    }
    
    private func hideSpinner() {
        spinner.hideMainSpinner()
    }
    
    private func updateStarButton() {
        if isStarred {
            starButton.setTitle("Starred", for: .normal)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            starButton.setTitle("Star", for: .normal)
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
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

extension RepositoryDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            showContributors()
        } else if indexPath.row == 1 {
            showCommits()
        } else if indexPath.row == 2 {
            showLicense()
        }
    }

}
