//
//  AsyncUIImageView.swift
//  GitIt
//
//  Created by Loay Ashraf on 05/12/2021.
//

import Foundation
import UIKit

class AsyncUIImageView: UIImageView {
    
    var loadingSpinner: UIActivityIndicatorView!
    var runningRequestUUID: UUID!
    
    required init?(coder: NSCoder) {
        loadingSpinner = UIActivityIndicatorView(style: .medium)
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.isUserInteractionEnabled = false
        super.init(coder: coder)
        loadingSpinner!.frame = bounds
        addSubview(loadingSpinner!)
    }
    
    func load(at url: URL, completion: @escaping (NetworkError?) -> Void) {
        if runningRequestUUID != nil { cancel() }
        loadingSpinner.startAnimating()
        runningRequestUUID = ImageLoader.standard.loadImage(url) { [weak self] result in
            switch result {
            case .success(let image): self?.image = image
                                      self?.loadingSpinner.stopAnimating()
            case .failure(let error): completion(error)
            }
        }
    }

    func cancel() {
        if runningRequestUUID != nil {
            ImageLoader.standard.cancelLoad(runningRequestUUID)
            runningRequestUUID = nil
            loadingSpinner.stopAnimating()
        }
    }
    
}
