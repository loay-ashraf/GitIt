//
//  SFDynamicTableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import UIKit
import SkeletonView

class SFDynamicTableView: TableView, StatefulView {
    
    // MARK: - Properties
    
    var state: ViewState = .presenting
    
    var errorAction: (() -> Void)?
    var footerErrorAction: (() -> Void)?
    
    private var curtainView: UIView!
    private var emptyView: EmptyView!
    private var activityIndicatorView: ActivityIndicatorView!
    private var footerActivityIndicatorView: FooterActivityIndicatorView!
    private var errorView: ErrorView!
    private var footerErrorView: FooterErrorView!
    
    // MARK: - Initialization
    
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
        case .initial:  showAnimatedSkeleton(transition: .crossDissolve(0.5))
                        isScrollEnabled = false
        case .refresh: return
        case .paginate: footerActivityIndicatorView.show()
        }
    }
    
    func hideActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial:  DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.hideSkeleton(transition: .crossDissolve(0.5))
                            self.isScrollEnabled = true
                        }
        case .refresh: refreshControl?.endRefreshing()
        case .paginate: footerActivityIndicatorView.hide()
        }
    }
    
    func showError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial(let error),.refresh(let error): errorView.show(on: self, with: ErrorViewModel(from: error)); isScrollEnabled = false
        case .paginate(let error): footerErrorView.show(with: ErrorViewModel(from: error))
        }
    }
    
    func hideError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial,.refresh: errorView.hide(); isScrollEnabled = true
        case .paginate: footerErrorView.hide()
        }
    }
    
}

