//
//  ActivityIndicatorView.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/12/2021.
//

import UIKit

class ActivityIndicatorView: UIView {
    
    @IBOutlet weak var spinnerContainer: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    class func instanceFromNib() -> ActivityIndicatorView {
        let bundle = Bundle(for: ActivityIndicatorView.self)
        let view = UINib(nibName: "ActivityIndicatorView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! ActivityIndicatorView
        view.configureView()
        return view
    }
    
    private func configureView() {
        spinnerContainer.cornerRadius = 10.0
        spinnerContainer.cornerCurve = .continuous
        spinnerContainer.masksToBounds = true
    }
    
    func show(on superView: UIView) {
        frame = superView.frame
        superView.addSubview(self)
        spinner.startAnimating()
    }
    
    func hide() {
        if let superView = self.superview {
            UIView.transition(with: superView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    self.removeFromSuperview()
            }, completion: nil)
            self.spinner.stopAnimating()
        }
    }

}
