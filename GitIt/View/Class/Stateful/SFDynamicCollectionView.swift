//
//  SFDynamicCollectionView.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/12/2021.
//

import UIKit

class SFDynamicCollectionView: UICollectionView, StatefulView {

    var state: ViewState = .presenting
    
    var registeredViews = [String:Any]()
    
    var errorAction: (() -> Void)?
    
    private var emptyView: EmptyView!
    private var activityIndicatorView: ActivityIndicatorView!
    private var errorView: ErrorView!
    
    // MARK: - Initialisation
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initializeSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSubviews()
    }
    
    private func initializeSubviews() {
        emptyView = EmptyView.instanceFromNib()
        activityIndicatorView = ActivityIndicatorView.instanceFromNib()
        errorView = ErrorView.instanceFromNib()
        errorView.configureAction { [ weak self ] in self?.errorAction!() }
    }
    
    // MARK: - View Registeration Methods

    override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        super.register(nib, forCellWithReuseIdentifier: identifier)
        if let nib = nib { registeredViews[identifier] = nib }
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
        case .presenting: reloadData()
        case .empty(let emptyContext): showEmpty(for: emptyContext)
        case .loading(let loadingViewState): showActivityIndicator(for: loadingViewState)
        case .failed(let failedViewState): showError(for: failedViewState)
        }
    }
    
    func showEmpty(for context: EmptyContext) {
        let emptyModel = context.model
        emptyView.show(on: self, with: emptyModel)
    }
    
    func showActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.show(on: self); self.isScrollEnabled = false
        default: return
        }
    }
    
    func hideActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.hide(); self.isScrollEnabled = true
        case .refresh: refreshControl?.endRefreshing()
        default: return
        }
    }
    
    func showError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial(let error),.refresh(let error): errorView.show(on: self, with: ErrorModel(from: error)); self.isScrollEnabled = false
        default: return
        }
    }
    
    func hideError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial,.refresh: errorView.hide(); self.isScrollEnabled = true
        default: return
        }
    }

}
