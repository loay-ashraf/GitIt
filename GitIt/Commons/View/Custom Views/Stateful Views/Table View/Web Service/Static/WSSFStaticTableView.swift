//
//  WSSFStaticTableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/12/2021.
//

import UIKit
import SVProgressHUD

class WSSFStaticTableView: UITableView, WSStatefulView {
    
    var state: ViewState = .presenting
    
    var isSuperView: Bool = false
    
    var updateView: (() -> Void)?
    
    var errorAction: (() -> Void)?
    
    private var curtainView: UIView!
    private var activityIndicatorView: ActivityIndicatorView!
    private var errorView: ErrorView!
    
    // MARK: - Initialisation
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initializeSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSubviews()
    }
    
    private func initializeSubviews() {
        curtainView = {
            let view = UIView(frame: frame)
            view.backgroundColor = .systemBackground
            return view
        }()
        curtainView.backgroundColor = .systemBackground
        activityIndicatorView = ActivityIndicatorView.instanceFromNib()
        errorView = ErrorView.instanceFromNib()
        errorView.configureAction { [ weak self ] in self?.errorAction!() }
    }
    
    // MARK: - View State Methods
    
    func transition(to viewState: ViewState) {
        defer { render(viewState) }
        switch state {
        case .loading(let loadingViewState): hideActivityIndicator(for: loadingViewState)
        case .failed(let failedViewState): hideError(for: failedViewState)
        default: return
        }
    }
    
    func render(_ viewState: ViewState) {
        state = viewState
        switch viewState {
        case .presenting: updateView?()
        case .loading(let loadingViewState): showActivityIndicator(for: loadingViewState)
        case .failed(let failedViewState): showError(for: failedViewState)
        default: return
        }
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
