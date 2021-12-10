//
//  LicenseViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import UIKit

class LicenseViewController: UIViewController, StoryboardViewController {
    
    static let storyboardIdentifier = "LicenseVC"
    
    private var logicController: LicenseLogicController
    private var model: String { return logicController.model }
    
    private var spinner: Spinner!
    
    @IBOutlet weak var licenseTextView: UITextView!
    
    // MARK: - Initialisation
    
    init?(coder: NSCoder, parameters: (String,String)) {
        logicController = LicenseLogicController(parameters: parameters)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiateFromStoryboard(with parameters: Any) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: LicenseViewController.storyboardIdentifier, creator: {coder ->                                  LicenseViewController in
                        LicenseViewController(coder: coder, parameters: parameters as! (String,String))!
                })
    }
    
    static func instatiateFromStoryboard<Type>(with model: Type) -> UIViewController where Type : Model {
        fatalError("This View controller is instaniated only using parameters")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        render(.loading)
        logicController.load(then: render(_:))
    }
    

    // MARK: - UI Helper Methods
    
    func render(_ state: LicenseViewState) {
        switch state {
        case .loading: showSpinner()
        case .presenting: hideSpinner()
                          updateUI()
        case .failed(let error): print(error)
        }
    }
    
    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .never
        
        spinner = Spinner(self)
    }
    
    private func updateUI() {
        licenseTextView.text = model
    }

    private func showSpinner() {
        spinner.showMainSpinner()
    }
    
    private func hideSpinner() {
        spinner.hideMainSpinner()
    }
    
}
