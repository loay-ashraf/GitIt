//
//  LicenseViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import UIKit

class LicenseViewController: UIViewController, IBViewController {
    
    static let storyboardIdentifier = "LicenseVC"
    
    var viewState: ViewState?
    
    private let logicController: LicenseLogicController
    private var model: String { return logicController.model }
    
    private var activityIndicatorView: ActivityIndicatorView!
    private var errorView: ErrorView!
    
    @IBOutlet weak var licenseTextView: UITextView!
    
    // MARK: - Initialisation
    
    init?(coder: NSCoder, parameters: (String,String)) {
        logicController = LicenseLogicController(parameters: parameters)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Fatal Error, this view controller shouldn't be instantiated via storyboard segue.")
    }
    
    static func instatiateWithParameters(with parameters: Any) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(identifier: LicenseViewController.storyboardIdentifier, creator: {coder ->                                  LicenseViewController in
                        LicenseViewController(coder: coder, parameters: parameters as! (String,String))!
                })
    }
    
    static func instatiateWithModel(with model: Any) -> UIViewController {
        fatalError("This View controller is instaniated only using parameters")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        load(with: .initial)
    }
    

    // MARK: - UI Helper Methods
    
    private func configureUI() {
        viewState = .presenting
        
        navigationItem.largeTitleDisplayMode = .never
        activityIndicatorView = ActivityIndicatorView.instanceFromNib()
    }
    
    private func updateUI() {
        licenseTextView.text = model
    }

    // MARK: - Loading Methods
    
    func load(with loadingViewState: LoadingViewState) {
        transition(to: .loading(loadingViewState))
        logicController.load(then: transition(to:))
    }
    
    // MARK: - View State Methods
    
    internal func transition(to viewState: ViewState) {
        switch self.viewState {
        case .loading(let loadingViewState): hideActivityIndicator(for: loadingViewState)
        case .failed: hideError()
        default: return
        }
        render(viewState)
    }
    
    internal func render(_ viewState: ViewState) {
        self.viewState = viewState
        switch viewState {
        case .empty(let emptyContext): return
        case .loading(let loadingViewState): showActivityIndicator(for: loadingViewState)
        case .presenting: updateUI()
        case .failed(let failedViewState): showError(with: failedViewState)
        }
    }
    
    internal func showActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.show(on: view)
        case .paginate: return
        default: return
        }
    }
    
    internal func hideActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.hide()
        case .paginate: return
        default: return
        }
    }
    
    internal func showError(with failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial(let error): errorView.show(on: view, with: ErrorViewModel(from: error))
        case .refresh(let error): errorView.show(on: view, with: ErrorViewModel(from: error))
        case .paginate: return
        }
    }
    
    internal func hideError() {
        errorView.hide()
    }
    
}
