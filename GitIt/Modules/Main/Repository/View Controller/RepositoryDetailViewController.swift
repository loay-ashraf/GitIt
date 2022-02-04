//
//  RepositoryDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 18/10/2021.
//

import UIKit
import MarkdownView

class RepositoryDetailViewController: SFStaticTableViewController, StoryboardableViewController {
    
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
        viewModel = RepositoryDetailViewModel(fullName: fullName)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, cellViewModel: RepositoryCellViewModel) {
        viewModel = RepositoryDetailViewModel(cellViewModel: cellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, model: RepositoryModel) {
        viewModel = RepositoryDetailViewModel(model: model)
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
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> RepositoryDetailViewController in
                        self.init(coder: coder, fullName: parameter)!
                })
    }
    
    static func instatiate<T: CellViewModel>(cellViewModel: T) -> UIViewController  {
        if let cellViewModel = cellViewModel as? RepositoryCellViewModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> RepositoryDetailViewController in
                            self.init(coder: coder, cellViewModel: cellViewModel)!
                    })
        } else {
            return UIViewController()
        }
    }
    
    static func instatiate<T: Model>(model: T) -> UIViewController  {
        if let model = model as? RepositoryModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> RepositoryDetailViewController in
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
        
        ownerTextView.action = { [weak self] in self?.viewModel.showOwner(navigationController: self?.navigationController) }
        homepageTextView.action = { [weak self] in self?.viewModel.goToHomepage() }
        starsNumericView.actions = [ { [weak self] in self?.viewModel.showStars(navigationController: self?.navigationController) } ]
        forksNumericView.actions = [ { [weak self] in self?.viewModel.showForks(navigationController: self?.navigationController) } ]
        
        switch UIApplication.shared.userInterfaceLayoutDirection {
        case .leftToRight: starButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15.0)
        case .rightToLeft: starButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 0)
        @unknown default: break
        }
        starButton.cornerRadius = 10
        
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
            if url.scheme == "https" || url.scheme == "http"  {
                URLHelper.openURL(url)
                return false
            } else { return false }
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
        updateBookmarkButton()
        updateStarButton()
        
        bookmarkButton.isEnabled = true
        openInSafariButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func star(_ sender: Any) {
        viewModel.starAction(then: updateStarButton)
    }
    
    @IBAction func bookmark(_ sender: UIBarButtonItem) {
        viewModel.bookmarkAction(then: updateBookmarkButton)
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
            viewModel.showContributors(navigationController: navigationController)
        } else if indexPath.row == 1 {
            viewModel.showCommits(navigationController: navigationController)
        } else if indexPath.row == 2 {
            viewModel.showLicense(navigationController: navigationController)
        }
    }
    
    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        viewModel.load(then: loadHandler(error:))
    }
    
}

extension RepositoryDetailViewController {
    
    // MARK: - View Helper Methods (Private)
    
    private func updateBookmarkButton() {
        if viewModel.isBookmarked {
            bookmarkButton.image = Constants.View.Button.bookmark.bookmarkedImage
        } else {
            bookmarkButton.image = Constants.View.Button.bookmark.defaultImage
        }
    }
    
    private func updateStarButton() {
        if viewModel.isStarred {
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
