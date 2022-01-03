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
        let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
        if superView.superview == nil {
            superView.frame.size.height = (window?.frame.height)! - subViewsOffsetSize.rawValue
        }
        frame = superView.frame
        superView.addSubview(self)
        spinner.startAnimating()
    }
    
    func show(on superView: UIView, with heightOffset: CGFloat) {
        frame = superView.frame
        frame.size.height -= heightOffset
        UIView.transition(with: superView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            superView.addSubview(self)
        }, completion: nil)
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
