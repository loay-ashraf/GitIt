//
//  CommitDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitDetailViewController: WSSFStaticTableViewController, StoryboardableViewController {

    // MARK: - Properties
    
    static let storyboardIdentifier = "CommitDetailVC"
    
    var viewModel: CommitDetailViewModel
    
    // MARK: - View Outlets
    
    @IBOutlet weak var authorTextView: IconicTextView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var openInSafariButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, cellViewModel: CommitCellViewModel) {
        viewModel = CommitDetailViewModel(tableCellViewModel: cellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, model: CommitModel) {
        viewModel = CommitDetailViewModel(model: model)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiate<T: TableCellViewModel>(tableCellViewModel: T) -> UIViewController  {
        if let cellViewModel = tableCellViewModel as? CommitCellViewModel {
            let storyBoard = StoryboardConstants.main
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> CommitDetailViewController in
                            self.init(coder: coder, cellViewModel: cellViewModel)!
                    })
        } else {
            return UIViewController()
        }
    }
    
    static func instatiate<T: Model>(model: T) -> UIViewController  {
        if let model = model as? CommitModel {
            let storyBoard = StoryboardConstants.main
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> CommitDetailViewController in
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
        
        authorTextView.action = { [weak self] in self?.showAuthor() }
    }
    
    override func updateView() {
        if let author = viewModel.author {
            authorTextView.loadIcon(at: author.avatarURL)
            authorTextView.text = author.login
        } else {
            authorTextView.text = nil
        }
        messageLabel.text = viewModel.message
        
        openInSafariButton.isEnabled = true
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func openInSafari(_ sender: UIBarButtonItem) {
        URLHelper.openWebsite(viewModel.htmlURL)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        URLHelper.shareWebsite(viewModel.htmlURL)
    }

    func showAuthor() {
        if let author = viewModel.author, author.type == .user {
            let authorLogin = author.login
            let authorDetailVC = UserDetailViewController.instatiate(parameter: authorLogin)
            NavigationRouter.push(viewController: authorDetailVC)
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
