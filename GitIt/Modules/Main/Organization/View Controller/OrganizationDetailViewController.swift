//
//  OrganizationDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import UIKit

class OrganizationDetailViewController: SFStaticTableViewController, IBViewController {

    static let storyboardIdentifier = "OrganizationDetailVC"
    
    private let logicController: OrganizationDetailLogicController
    private var model: OrganizationModel { return logicController.model }
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var avatarImageView: SFImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationTextView: IconicTextView!
    @IBOutlet weak var blogTextView: IconicTextView!
    @IBOutlet weak var emailTextView: IconicTextView!
    @IBOutlet weak var twitterTextView: IconicTextView!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var openInSafariButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, model: OrganizationModel) {
        logicController = OrganizationDetailLogicController(model)
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
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: {coder -> OrganizationDetailViewController in
                    self.init(coder: coder, model: model as! OrganizationModel)!
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
    }
    
    override func updateView() {
        avatarImageView.load(at: model.avatarURL)
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
        locationTextView.text = model.location
        blogTextView.text = model.blogURL?.absoluteString
        emailTextView.text = model.email
        twitterTextView.text = model.twitter != nil ? "@".appending(model.twitter!) : nil
        
        bookmarkButton.isEnabled = true
        openInSafariButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
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
    
    func showMemebers() {
        let usersVC = UserViewController.instatiateWithContext(with: .members(organizationLogin: model.login))
        navigationController?.pushViewController(usersVC, animated: true)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController.instatiateWithContext(with: .user(userLogin: model.login, numberOfRepositories: model.repositories!))
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
    override func showViewController(forRowAt indexPath: IndexPath) {
        super.showViewController(forRowAt: indexPath)
        if indexPath.row == 0 {
            showMemebers()
        } else if indexPath.row == 1 {
            showRepositories()
        }
    }
    
    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        logicController.load(then: loadHandler(error:), then: updateBookmarkButton(isBookmarked:))
    }
    
}

extension OrganizationDetailViewController {
    
    // MARK: - View Actions (private)
    
    private func updateBookmarkButton(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.image = UIImage(systemName: "bookmark.fill")
        } else {
            bookmarkButton.image = UIImage(systemName: "bookmark")
        }
    }
    
}

extension OrganizationDetailViewController: UIContextMenuInteractionDelegate {
    
    // MARK: - Context Menu Delegate
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        if let image = avatarImageView.image {
            return ContextMenuConfigurationConstants.SaveImageConfiguration(for: image)
        } else {
            return UIContextMenuConfiguration()
        }
    }
    
}
