//
//  LicenseViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import UIKit

class LicenseViewController: SFViewController, IBViewController {
    
    static let storyboardIdentifier = "LicenseVC"
    
    private let logicController: LicenseLogicController
    private var model: String { return logicController.model }
    
    @IBOutlet weak var licenseTextView: UITextView!
    
    // MARK: - Initialisation
    
    init?(coder: NSCoder, repositoryFullName: String, defaultBranch: String) {
        logicController = LicenseLogicController(repositoryFullName: repositoryFullName, defaultBranch: defaultBranch)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiateWithParameters(with parameters: Any) -> UIViewController {
        fatalError("This View controller is instaniated only using parameters")
    }
    
    static func instatiateWithParameters(repositoryFullName: String, defaultBranch: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: LicenseViewController.storyboardIdentifier, creator: {coder ->                                  LicenseViewController in
                        LicenseViewController(coder: coder, repositoryFullName: repositoryFullName, defaultBranch: defaultBranch)!
                })
    }
    
    static func instatiateWithModel(with model: Any) -> UIViewController {
        fatalError("This View controller is instaniated only using parameters")
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
    }
    
    override func updateView() {
        licenseTextView.text = model
    }

    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        logicController.load(then: loadHandler(error:))
    }
    
}
