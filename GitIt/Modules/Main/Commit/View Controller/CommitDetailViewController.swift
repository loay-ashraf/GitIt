//
//  CommitDetailViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 14/12/2021.
//

import UIKit

class CommitDetailViewController: SFStaticTableViewController, IBViewController {

    static let storyboardIdentifier = "CommitDetailVC"
    
    private let logicController: CommitDetailLogicController
    private var model: CommitModel { return logicController.model }
    
    // MARK: - UI Outlets
    
    @IBOutlet weak var authorTextView: IconicTextView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder, model: CommitModel) {
        logicController = CommitDetailLogicController(model)
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
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: {coder -> CommitDetailViewController in
                        self.init(coder: coder, model: model as! CommitModel)!
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
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        
        navigationItem.largeTitleDisplayMode = .never
        
        authorTextView.action = { [weak self] in self?.showOwner() }
    }
    
    override func updateView() {
        if let author = model.author {
            authorTextView.loadIcon(at: author.avatarURL)
            authorTextView.text = author.login
        } else {
            authorTextView.text = nil
        }
        messageLabel.text = model.message
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func share(_ sender: Any) {
        let htmlURL = model.htmlURL
        URLHelper.shareURL(htmlURL)
    }
    
    func showOwner() {
        if model.author != nil && model.author!.type == .user {
            let userModel = UserModel(from: model.author!)
            let userDetailVC = UserDetailViewController.instatiateWithModel(with: userModel)
            navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
    
    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        logicController.load(then: loadHandler(error:))
    }
    
}
