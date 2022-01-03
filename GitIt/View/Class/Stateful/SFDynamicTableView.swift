//
//  SFDynamicTableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import UIKit

class SFDynamicTableView: UITableView, StatefulView {
    
    var state: ViewState = .presenting
    
    lazy var registeredNibs = [UINib]()
    lazy var registeredCellIdentifiers = [String]()
    
    var errorAction: (() -> Void)?
    var footerErrorAction: (() -> Void)?
    
    private var emptyView: EmptyView!
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
        emptyView = EmptyView.instanceFromNib()
        activityIndicatorView = ActivityIndicatorView.instanceFromNib()
        footerActivityIndicatorView = FooterActivityIndicatorView.instanceFromNib()
        footerActivityIndicatorView.add(to: self)
        errorView = ErrorView.instanceFromNib()
        errorView.configureAction { [ weak self ] in self?.errorAction!() }
        footerErrorView = FooterErrorView.instanceFromNib()
        footerErrorView.add(to: self)
        footerErrorView.configureAction { [ weak self ] in self?.footerErrorAction!() }
    }
    
    // MARK: - Cell Registeration Methods

    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        super.register(nib, forCellReuseIdentifier: identifier)
        if let nib = nib { registeredNibs.append(nib) }
        registeredCellIdentifiers.append(identifier)
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
        case .presenting: reloadData()
        case .empty(let emptyContext): showEmpty(for: emptyContext)
        case .loading(let loadingViewState): showActivityIndicator(for: loadingViewState)
        case .failed(let failedViewState): showError(for: failedViewState)
        }
    }
    
    func showEmpty(for context: EmptyContext) {
        let emptyModel = context.model
        emptyView.show(on: self, with: emptyModel)
        isScrollEnabled = false
    }
    
    func hideEmpty() {
        emptyView.hide()
        isScrollEnabled = true
    }
    
    func showActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.show(on: self); isScrollEnabled = false
        case .refresh: return
        case .paginate: footerActivityIndicatorView.show()
        }
    }
    
    func hideActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.hide(); isScrollEnabled = true
        case .refresh: refreshControl?.endRefreshing()
        case .paginate: footerActivityIndicatorView.hide()
        }
    }
    
    func showError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial(let error),.refresh(let error): errorView.show(on: self, with: ErrorModel(from: error)); isScrollEnabled = false
        case .paginate(let error): footerErrorView.show(with: ErrorModel(from: error))
        }
    }
    
    func hideError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial,.refresh: errorView.hide(); isScrollEnabled = true
        case .paginate: footerErrorView.hide()
        }
    }
    
}
