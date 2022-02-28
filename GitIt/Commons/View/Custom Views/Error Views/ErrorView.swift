//
//  ErrorView.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/12/2021.
//

import UIKit

class ErrorView: UIView {

    private var action: (() -> Void)!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    class func instanceFromNib() -> ErrorView {
        let bundle = Bundle(for: ErrorView.self)
        let view = UINib(nibName: "ErrorView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! ErrorView
        view.configureView()
        return view
    }
    
    @IBAction func tryAgain (_ sender: UIButton) {
        action()
    }
    
    private func configureView() {
        actionButton.cornerRadius = 10.0
        actionButton.cornerCurve  = .continuous
        actionButton.masksToBounds = true
    }
    
    func configureAction(action: @escaping () -> Void) {
        self.action = action
    }
    
    func show(on superView: UIView, with errorModel: ErrorViewModel?) {
        imageView.image = errorModel?.image
        titleLabel.text = errorModel?.title
        messageLabel.text = errorModel?.message
        frame = superView.bounds
        superView.addSubview(self)
    }
    
    func hide() {
        if let superView = self.superview {
            UIView.transition(with: superView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                    self.removeFromSuperview()
            }, completion: nil)
        }
    }

}
