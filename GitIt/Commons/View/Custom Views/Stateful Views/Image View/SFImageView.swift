//
//  SFImageView.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import UIKit
import Kingfisher

class SFImageView: UIImageView, WSStatefulView {
    
    var state: ViewState = .presenting
    var processor: ImageProcessor!
    
    // MARK: - Initialisation
    
    // This initializer is required to avoid IBDesignable agent to crash
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        kf.indicatorType = .activity
        processor = DownsamplingImageProcessor(size: bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 20)
    }
    
    // MARK: - Loading Methods
    
    func load(at url: URL) {
        kf.cancelDownloadTask()
        transition(to: .loading(.initial))
        kf.setImage(with: url, placeholder: nil, options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ], completionHandler: { [weak self] result in
            switch result {
            case .success: self?.transition(to: .presenting)
            case .failure(KingfisherError.imageSettingError(.notCurrentSourceTask)): break
            case .failure(let error): self?.transition(to: .failed(.initial(error)))
            }
        })
    }

    func cancel() {
        kf.cancelDownloadTask()
        transition(to: .presenting)
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
        case .initial: kf.indicator?.startAnimatingView()
        default: return
        }
    }
    
    func hideActivityIndicator(for loadingViewState: LoadingViewState) {
        switch loadingViewState {
        case .initial: kf.indicator?.stopAnimatingView()
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
