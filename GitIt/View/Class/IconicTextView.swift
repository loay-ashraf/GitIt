//
//  IconicTextView.swift
//  GitIt
//
//  Created by Loay Ashraf on 09/01/2022.
//

import UIKit

@IBDesignable
class IconicTextView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconImageView: SFImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBInspectable var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    @IBInspectable var iconCornerRadius: CGFloat = 0.0 {
        didSet {
            iconImageView.cornerRadius = iconCornerRadius
            iconImageView.cornerCurve = .continuous
            iconImageView.masksToBounds = true
        }
    }
    
    @IBInspectable var text: String? {
        didSet {
            if let text = text {
                textLabel.text = text
                isHidden = false
            } else {
                isHidden = true
            }
        }
    }
    
    @IBInspectable var isLink: Bool = false {
        didSet {
            if isLink {
                textLabel.font = UIFont.boldSystemFont(ofSize: textLabel.font.pointSize)
                textLabel.isUserInteractionEnabled = true
            } else {
                textLabel.font = UIFont.systemFont(ofSize: textLabel.font.pointSize)
                textLabel.isUserInteractionEnabled = false
            }
        }
    }
    
    var action: (() -> Void)?
    
    @IBAction func textTapped(_ sender: UITapGestureRecognizer) {
        action?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    func instantiateFromNib() -> UIView? {
        let bundle = Bundle(for: IconicNumericView.self)
        let nib = UINib(nibName: "IconicTextView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureView() {
        guard let view = instantiateFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        sizeToFit()
    }
    
    func loadImage(at url: URL) {
        iconImageView.load(at: url)
    }

}
