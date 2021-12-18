//
//  OrganizationDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import UIKit

class OrganizationDetailViewController: UITableViewController, StoryboardViewController {

    static let storyboardIdentifier = "OrganizationDetailVC"
    
    private var logicController: OrganizationDetailLogicController
    private var model: OrganizationModel { return logicController.model }
    private var isBookmarked: Bool { return logicController.isBookmarked }
    
    private var spinner: Spinner!
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var avatarImageView: AsyncUIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var blogStackView: UIStackView!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var twitterStackView: UIStackView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var blogLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, model: OrganizationModel) {
        logicController = OrganizationDetailLogicController(model)
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
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: {coder -> OrganizationDetailViewController in
                    self.init(coder: coder, model: model as! OrganizationModel)!
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
    
    func showMemebers() {
        let usersVC = UserViewController(context: .members, contextParameters: model.login)
        navigationController?.pushViewController(usersVC, animated: true)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController(context: .user, contextParameters: (model.login,model.repositories!))
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
}

extension OrganizationDetailViewController {
    
    // MARK: - UI Helper Methods
    
    func render(_ state: OrganizationDetailViewState) {
        switch state {
        case .loading: showSpinner()
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

    }
    
    private func updateUI() {
        avatarImageView.load(at: model.avatarURL) { networkError in print(networkError) }
        if model.name != nil {
            fullNameLabel.text = model.name
        } else  {
            fullNameLabel.isHidden = true
        }
        loginLabel.text = model.login
        if model.description != nil {
            descriptionLabel.text = model.description
        } else {
            descriptionLabel.isHidden = true
        }
        if model.location != nil {
            locationLabel.text = model.location
        } else {
            locationStackView.isHidden = true
        }
        if model.blogURL != nil {
            blogLabel.text = model.blogURL?.absoluteString
        } else {
            blogStackView.isHidden = true
        }
        if model.email != nil {
            emailLabel.text = model.email
        } else {
            emailStackView.isHidden = true
        }
        if model.twitter != nil {
            let atCharacter = "@"
            twitterLabel.text = atCharacter + model.twitter!
        } else {
            twitterStackView.isHidden = true
        }
        bookmarkButton.isEnabled = true
        shareButton.isEnabled = true
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
    
    private func showSpinner() {
        spinner.showMainSpinner()
    }
    
    private func hideSpinner() {
        spinner.hideMainSpinner()
    }
    
    private func updateBookmarkButton() {
        if isBookmarked {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkButton.image = UIImage(systemName: "bookmark")
        }
    }
    
}

extension OrganizationDetailViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            showMemebers()
        } else if indexPath.row == 1 {
            showRepositories()
        }
    }

}
