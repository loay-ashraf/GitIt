//
//  LicenseViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import UIKit

class LicenseViewController: WSSFViewController, StoryboardableViewController {
    
    // MARK: - Properties
    
    static let storyboardIdentifier = "LicenseVC"
    
    var viewModel: LicenseViewModel
    
    // MARK: - View Outlets
    
    @IBOutlet weak var licenseTextView: UITextView!
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder, repositoryFullName: String, defaultBranch: String) {
        viewModel = LicenseViewModel(parameter: repositoryFullName, defaultBranch: defaultBranch)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiate(parameters: [String]) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: self.storyboardIdentifier, creator: { coder -> LicenseViewController in
                    self.init(coder: coder, repositoryFullName: parameters[0], defaultBranch: parameters[1])!
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
    }
    
    override func updateView() {
        licenseTextView.text = viewModel.licenseText
    }

    // MARK: - Loading Methods
    
    override func load() {
        super.load()
        viewModel.load(then: loadHandler(error:))
    }
    
}
