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
    
    func load(at url: URL) {
        if runningRequestUUID != nil { cancel() }
        loadingSpinner.startAnimating()
        runningRequestUUID = ImageLoader.standard.loadImage(url) { [weak self] result in
            do {
                let image = try result.get()
                self?.image = image
                self?.loadingSpinner.stopAnimating()
            } catch {
                fatalError("Failed to load image \(self?.description)")
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
