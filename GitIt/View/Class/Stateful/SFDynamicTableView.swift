//
//  SFDynamicTableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import UIKit

class SFDynamicTableView: UITableView, StatefulView {
    
    var state: ViewState = .presenting
    
    var errorAction: (() -> Void)?
    var footerErrorAction: (() -> Void)?
    
    private var activityIndicatorView: ActivityIndicatorView!
    private var footerActivityIndicatorView: FooterActivityIndicatorView!
    private var errorView: ErrorView!
    private var footerErrorView: FooterErrorView!
    
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
        activityIndicatorView = ActivityIndicatorView.instanceFromNib()
        footerActivityIndicatorView = FooterActivityIndicatorView.instanceFromNib()
        footerActivityIndicatorView.add(to: self)
        errorView = ErrorView.instanceFromNib()
        errorView.configureAction { [ weak self ] in self?.errorAction!() }
        footerErrorView = FooterErrorView.instanceFromNib()
        footerErrorView.add(to: self)
        footerErrorView.configureAction { [ weak self ] in self?.footerErrorAction!() }
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
        case .loading(let loadingViewState): showActivityIndicator(for: loadingViewState)
        case .presenting: reloadData() 
        case .failed(let failedViewState): showError(for: failedViewState)
        }
    }
    
    func showActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.show(on: self); self.isScrollEnabled = false
        case .refresh: return
        case .paginate: footerActivityIndicatorView.show()
        }
    }
    
    func hideActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.hide(); self.isScrollEnabled = true
        case .refresh: refreshControl?.endRefreshing()
        case .paginate: footerActivityIndicatorView.hide()
        }
    }
    
    func showError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial(let error),.refresh(let error): errorView.show(on: self, with: ErrorModel(from: error)); self.isScrollEnabled = false
        case .paginate(let error): footerErrorView.show(with: ErrorModel(from: error))
        }
    }
    
    func hideError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial,.refresh: errorView.hide(); self.isScrollEnabled = true
        case .paginate: footerErrorView.hide()
        }
    }
    
}
