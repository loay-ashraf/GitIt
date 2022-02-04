//
//  CommitDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitDetailViewController: SFStaticTableViewController, StoryboardableViewController {

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
        viewModel = CommitDetailViewModel(cellViewModel: cellViewModel)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder, model: CommitModel) {
        viewModel = CommitDetailViewModel(model: model)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiate<T: ViewControllerContext>(context: T) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using cellViewModel or model")
    }
    
    static func instatiate(parameter: String) -> UIViewController {
        fatalError("Fatal Error, This View controller is instaniated only using cellViewModel or model")
    }
    
    static func instatiate<T: CellViewModel>(cellViewModel: T) -> UIViewController  {
        if let cellViewModel = cellViewModel as? CommitCellViewModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> CommitDetailViewController in
                            self.init(coder: coder, cellViewModel: cellViewModel)!
                    })
        } else {
            return UIViewController()
        }
    }
    
    static func instatiate<T: Model>(model: T) -> UIViewController  {
        if let model = model as? CommitModel {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
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
        viewModel.openInSafari()
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        viewModel.share()
    }
    
    func showAuthor() {
        viewModel.showAuthor(navigationController: navigationController)
    }
    
    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        viewModel.load(then: loadHandler(error:))
    }
    
}
