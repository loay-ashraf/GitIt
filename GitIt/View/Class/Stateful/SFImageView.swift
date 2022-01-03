//
//  SFImageView.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import Foundation
import UIKit

class SFImageView: UIImageView, StatefulView {
    
    var state: ViewState = .presenting
    
    var activityIndicatorView: UIActivityIndicatorView!
    var runningRequestUUID: UUID!
    
    // MARK: - Initialisation
    
    required init?(coder: NSCoder) {
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.isUserInteractionEnabled = false
        super.init(coder: coder)
        activityIndicatorView!.frame = bounds
        addSubview(activityIndicatorView!)
    }
    
    // MARK: - Loading Methods
    
    func load(at url: URL) {
        if runningRequestUUID != nil { cancel() }
        transition(to: .loading(.initial))
        runningRequestUUID = ImageLoader.standard.loadImage(url) { [weak self] result in
            switch result {
            case .success(let image): self?.image = image; self?.transition(to: .presenting)
            case .failure(NetworkError.client(let clientError)): if (clientError as NSError).code == NSURLErrorCancelled { return }
            case .failure(let networkError): self?.transition(to: .failed(.initial(networkError)))
            }
        }
    }

    func cancel() {
        if runningRequestUUID != nil {
            ImageLoader.standard.cancelLoad(runningRequestUUID)
            runningRequestUUID = nil
            transition(to: .presenting)
        }
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
        case .failed(let failedViewState): showError(for: failedViewState)
        default: return
        }
    }
    
    func showActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.startAnimating()
        default: return
        }
    }
    
    func hideActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: activityIndicatorView.stopAnimating()
        default: return
        }
    }
    
    func showError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial: image = UIImage(systemName: "exclamationmark.circle")
        default: return
        }
    }
    
    func hideError(for failedViewState: FailedViewState) {
        switch failedViewState {
        case .initial: image = nil
        default: return
        }
    }
    
}
