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
        let view = UINib(nibName: "ActivityIndicatorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ActivityIndicatorView
        view.configureUI()
        return view
    }
    
    private func configureUI() {
        spinnerContainer.cornerRadius = 10.0
        spinnerContainer.cornerCurve = .continuous
        spinnerContainer.masksToBounds = true
    }
    
    func show() {
        let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
        frame = window!.frame
        window!.addSubview(self)
        spinner.startAnimating()
    }
    
    func show(on superView: UIView) {
        frame = superView.bounds
        superView.addSubview(self)
        spinner.startAnimating()
    }
    
    func show(on superView: UIView, with heightOffset: CGFloat) {
        frame = superView.bounds
        frame.origin.y -= heightOffset
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
