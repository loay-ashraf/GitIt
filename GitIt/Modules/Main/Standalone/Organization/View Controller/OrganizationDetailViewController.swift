//
//  OrganizationDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import UIKit

class OrganizationDetailViewController: WSSFStaticTableViewController, StoryboardableViewController {

    // MARK: - Properties
    
    static let storyboardIdentifier = "OrganizationDetailVC"
    
    var viewModel: OrganizationDetailViewModel
    
    // MARK: - View Outlets
    
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
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, login: String) {
        viewModel = OrganizationDetailViewModel(withParameter: login)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, collectionCellViewModel: OrganizationCollectionCellViewModel) {
        viewModel = OrganizationDetailViewModel(collectionCellViewModel: collectionCellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, tableCellViewModel: OrganizationTableCellViewModel) {
        viewModel = OrganizationDetailViewModel(tableCellViewModel: tableCellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiate(parameter: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> OrganizationDetailViewController in
                        self.init(coder: coder, login: parameter)!
                })
    }
    
    static func instatiate<T: CollectionCellViewModel>(collectionCellViewModel: T) -> UIViewController  {
        if let cellViewModel = collectionCellViewModel as? OrganizationCollectionCellViewModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> OrganizationDetailViewController in
                            self.init(coder: coder, collectionCellViewModel: cellViewModel)!
                    })
        } else {
            return UIViewController()
        }
    }
    
    static func instatiate<T: TableCellViewModel>(tableCellViewModel: T) -> UIViewController  {
        if let cellViewModel = tableCellViewModel as? OrganizationTableCellViewModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> OrganizationDetailViewController in
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
        
        avatarImageView.addInteraction(UIContextMenuInteraction(delegate: self))
        
        blogTextView.action = { [weak self] in self?.goToBlog() }
        emailTextView.action = { [weak self] in self?.composeMail() }
        twitterTextView.action = { [weak self] in self?.goToTwitter() }
    }
    
    override func updateView() {
        avatarImageView.load(at: viewModel.avatarURL)
        if viewModel.name != nil {
            fullNameLabel.text = viewModel.name
        } else  {
            fullNameLabel.isHidden = true
        }
        loginLabel.text = viewModel.login
        if viewModel.description != nil {
            descriptionLabel.text = viewModel.description
        } else {
            descriptionLabel.isHidden = true
        }
        locationTextView.text = viewModel.location
        blogTextView.text = viewModel.blogURL?.absoluteString
        emailTextView.text = viewModel.email
        twitterTextView.text = viewModel.twitter != nil ? "@".appending(viewModel.twitter!) : nil
        
        Task {
            let status = await viewModel.checkForStatus()
            updateBookmarkButton(isBookmarked: status[0])
        }
        
        bookmarkButton.isEnabled = true
        openInSafariButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func bookmark(_ sender: UIBarButtonItem) {
        updateBookmarkButton(isBookmarked: viewModel.toggleBookmark())
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
    
    func showMembers() {
        let membersVC = UserViewController.instatiate(context: .members(organizationLogin: viewModel.login) as UserContext)
        NavigationRouter.push(viewController: membersVC)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController.instatiate(context: .user(userLogin: viewModel.login, numberOfRepositories: viewModel.repositories) as RepositoryContext)
        NavigationRouter.push(viewController: repositoriesVC)
    }
    
    override func showViewController(forRowAt indexPath: IndexPath) {
        super.showViewController(forRowAt: indexPath)
        if indexPath.row == 0 {
            showMembers()
        } else if indexPath.row == 1 {
            showRepositories()
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

extension OrganizationDetailViewController {
    
    // MARK: - View Helper Methods (private)
    
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
            let actionProvider = ImageActionProvider(saveImage: { UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) })
            return ContextMenuConfigurationConstants.SaveImageConfiguration(with: actionProvider)
        } else {
            return UIContextMenuConfiguration()
        }
    }
    
}
