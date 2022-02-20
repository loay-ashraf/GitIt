//
//  IconicNumericView.swift
//  GitIt
//
//  Created by Loay Ashraf on 08/01/2022.
//

import UIKit

@IBDesignable
class IconicNumericView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var separatorImageView: UIImageView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    
    @IBInspectable var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    @IBInspectable var iconTintColor: UIColor? {
        didSet {
            iconImageView.tintColor = iconTintColor
        }
    }
    
    @IBInspectable var iconCornerRadius: CGFloat = 0.0 {
        didSet {
            iconImageView.cornerRadius = iconCornerRadius
            iconImageView.cornerCurve = .continuous
            iconImageView.masksToBounds = true
        }
    }
    
    @IBInspectable var numberOfSections: Int = 2 {
        didSet {
            switch numberOfSections {
            case 1: separatorImageView.isHidden = true
                    secondNumberLabel.isHidden = true
                    secondTextLabel.isHidden = true
            case 2: separatorImageView.isHidden = false
                    secondNumberLabel.isHidden = false
                    secondTextLabel.isHidden = false
            default: break
            }
        }
    }
    
    @IBInspectable var firstText: String? {
        get { return firstTextLabel.text }
        set(text) { firstTextLabel.text = text?.localized() }
    }
    
    @IBInspectable var secondText: String? {
        get { return secondTextLabel.text }
        set(text) { secondTextLabel.text = text?.localized() }
    }
    
    @IBInspectable var isLink: Bool = false {
        didSet {
            if isLink {
                firstStackView.isUserInteractionEnabled = true
                secondStackView.isUserInteractionEnabled = true
                firstNumberLabel.font = UIFont.boldSystemFont(ofSize: firstNumberLabel.font.pointSize)
                secondNumberLabel.font = UIFont.boldSystemFont(ofSize: secondNumberLabel.font.pointSize)
            } else {
                firstStackView.isUserInteractionEnabled = false
                secondStackView.isUserInteractionEnabled = false
                firstNumberLabel.font = UIFont.systemFont(ofSize: firstNumberLabel.font.pointSize)
                secondNumberLabel.font = UIFont.systemFont(ofSize: secondNumberLabel.font.pointSize)
            }
        }
    }
    
    @IBInspectable var showDescriptiveText: Bool = false {
        didSet {
            if showDescriptiveText {
                firstTextLabel.isHidden = false
                secondTextLabel.isHidden = false
            } else {
                firstTextLabel.isHidden = true
                secondTextLabel.isHidden = true
            }
        }
    }
    
    @IBAction func firstNumberTapped(_ sender: UITapGestureRecognizer) {
        actions?[0]()
    }
    
    @IBAction func secondNumberTapped(_ sender: UITapGestureRecognizer) {
        actions?[1]()
    }
    
    var numbers: [Double]? {
        didSet {
            if let numbers = numbers, !numbers.isEmpty {
                firstNumberLabel.text = formatPoints(num: numbers[0])
                if numberOfSections >= 2 {
                    secondNumberLabel.text = formatPoints(num: numbers[1])
                }
            }
        }
    }
    
    var actions: [() -> Void]?
    
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
        let nib = UINib(nibName: "IconicNumericView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureView() {
        guard let view = instantiateFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }
    
}

func formatPoints(num: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 1
    let thousandNum = num/1000
    let millionNum = num/1000000
    if num >= 1000 && num < 1000000{
        let number = NSNumber(value: thousandNum)
        let formattedString = formatter.string(from: number)
        let finalString = formattedString! + "K".localized()
        return finalString
    }
    if num > 1000000{
        let number = NSNumber(value: millionNum)
        let formattedString = formatter.string(from: number)
        let finalString = formattedString! + "M".localized()
        return finalString
    }
    else{
        let number = NSNumber(value: num)
        let formattedString = formatter.string(from: number)
        return formattedString!
    }
}
