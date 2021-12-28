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
    
    @IBOutlet weak var avatarImageView: SFImageView!
    @IBOutlet weak var loginLabel: UILabel!
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
    
    static func instatiateFromStoryboard(with parameters: Any) -> UIViewController {
        fatalError("This View controller is instaniated only using a model")
    }
    
    static func instatiateFromStoryboard<Type: Model>(with model: Type) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: {coder -> CommitDetailViewController in
                        self.init(coder: coder, model: model as! CommitModel)!
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
    }
    
    override func updateView() {
        if model.author != nil {
            avatarImageView.load(at: model.author!.avatarURL)
            loginLabel.text = model.author!.login
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
            loginLabel.text = "No author found"
        }
        messageLabel.text = model.message
        shareButton.isEnabled = true
    }
    
    // MARK: - View Actions
    
    @IBAction func share(_ sender: Any) {
        let htmlURL = model.htmlURL
        URLHelper.shareURL(htmlURL)
    }
    
    @objc func saveAvatar(_ sender: UILongPressGestureRecognizer) {
        if model.author != nil && sender.state == .ended {
            UIImageWriteToSavedPhotosAlbum(avatarImageView.image!, self, nil, nil)
        }
    }
    
    @objc func showOwner() {
        if model.author != nil && model.author!.type == .user {
            let userModel = UserModel(from: model.author!)
            let userDetailVC = UserDetailViewController.instatiateFromStoryboard(with: userModel)
            navigationController?.pushViewController(userDetailVC, animated: true)
        }
    }
    
    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        logicController.load(then: loadHandler(error:))
    }
    
}
