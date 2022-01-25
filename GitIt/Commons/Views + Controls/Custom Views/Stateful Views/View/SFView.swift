//
//  SFView.swift
//  GitIt
//
//  Created by Loay Ashraf on 31/12/2021.
//

import UIKit
import SVProgressHUD

class SFView: UIView {

    var state: ViewState = .presenting
    
    var isSuperView: Bool = false
    
    var scrollView: UIScrollView?
    var isScrollEnabled: Bool? {
        get { return scrollView?.isScrollEnabled }
        set { scrollView?.isScrollEnabled = newValue! }
    }
    
    var updateView: (() -> Void)?
    
    var errorAction: (() -> Void)?
    
    private var curtainView: UIView!
    private var emptyView: EmptyView!
    private var activityIndicatorView: ActivityIndicatorView!
    private var errorView: ErrorView!
    
    // MARK: - Initialisation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSubviews()
    }
    
    private func initializeSubviews() {
        for subview in subviews {
            if subview.self is UIScrollView { scrollView = subview as? UIScrollView; break}
        }
        curtainView = {
            let view = UIView(frame: frame)
            view.backgroundColor = .systemBackground
            return view
        }()
        emptyView = EmptyView.instanceFromNib()
        activityIndicatorView = ActivityIndicatorView.instanceFromNib()
        errorView = ErrorView.instanceFromNib()
        errorView.configureAction { [ weak self ] in self?.errorAction!() }
    }
    
    // MARK: - View State Methods
    
    func transition(to viewState: ViewState) {
        if !state.isTransionable(to: viewState) { return }
        switch state {
        case .empty: hideEmpty()
        case .loading(let loadingViewState): hideActivityIndicator(for: loadingViewState)
        case .failed(let failedViewState): hideError(for: failedViewState)
        default: break
        }
        render(viewState)
    }
    
    func render(_ viewState: ViewState) {
        state = viewState
        switch viewState {
        case .presenting: updateView?(); scrollView?.isScrollEnabled = true
        case .empty(let emptyContext): showEmpty(for: emptyContext)
        case .loading(let loadingViewState): showActivityIndicator(for: loadingViewState)
        case .failed(let failedViewState): showError(for: failedViewState)
        }
    }
    
    func showEmpty(for model: EmptyViewModel) {
        emptyView.show(on: self, with: model)
        isScrollEnabled = false
    }
    
    func hideEmpty() {
        emptyView.hide()
        isScrollEnabled = true
    }
    
    func showActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: if isSuperView == false, !SVProgressHUD.isVisible() {
                            activityIndicatorView.show(on: self)
                        } else if isSuperView {
                            addSubview(curtainView)
                            SVProgressHUD.show()
                        }
                        isScrollEnabled = false
        default: return
        }
    }
    
    func hideActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: if isSuperView == false, !SVProgressHUD.isVisible() {
                            activityIndicatorView.hide()
                        } else if isSuperView {
                            curtainView.removeFromSuperview()
                            SVProgressHUD.dismiss(withDelay: 0.5)
                        }
                        isScrollEnabled = true
        default: return
        }
    }
    
    func showError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial(let error): errorView.show(on: self, with: ErrorViewModel(from: error)); isScrollEnabled = false
        default: return
        }
    }
    
    func hideError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial: errorView.hide(); isScrollEnabled = true
        default: return
        }
    }

}
