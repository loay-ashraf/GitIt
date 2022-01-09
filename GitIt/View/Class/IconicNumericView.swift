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
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var firstTextLabel: UILabel!
    @IBOutlet weak var separatorImageView: UIImageView!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var secondTextLabel: UILabel!
    
    @IBInspectable var icon: UIImage? {
        get { return iconImageView.image }
        set(image) { iconImageView.image = image }
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
        set(text) { firstTextLabel.text = text }
    }
    
    @IBInspectable var secondText: String? {
        get { return secondTextLabel.text }
        set(text) { secondTextLabel.text = text }
    }
    
    @IBInspectable var isLink: Bool = false {
        didSet {
            if isLink {
                firstNumberLabel.font = UIFont.boldSystemFont(ofSize: firstNumberLabel.font.pointSize)
                firstNumberLabel.isUserInteractionEnabled = true
                secondNumberLabel.font = UIFont.boldSystemFont(ofSize: secondNumberLabel.font.pointSize)
                secondNumberLabel.isUserInteractionEnabled = true
            } else {
                firstNumberLabel.font = UIFont.systemFont(ofSize: firstNumberLabel.font.pointSize)
                firstNumberLabel.isUserInteractionEnabled = false
                secondNumberLabel.font = UIFont.systemFont(ofSize: secondNumberLabel.font.pointSize)
                secondNumberLabel.isUserInteractionEnabled = false
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
            firstNumberLabel.text = formatPoints(num: numbers![0])
            secondNumberLabel.text = formatPoints(num: numbers![1])
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
    let thousandNum = num/1000
    let millionNum = num/1000000
    if num >= 1000 && num < 1000000{
        if(thousandNum.truncatingRemainder(dividingBy: 1) < 0.1){
            return("\(Int(thousandNum))K")
        }
        return("\(thousandNum.truncate(places: 1))K")
    }
    if num > 1000000{
        if(millionNum.truncatingRemainder(dividingBy: 1) < 0.1){
            return("\(Int(thousandNum))M")
        }
        return("\(millionNum.truncate(places: 1))M")
    }
    else{
        if(num.truncatingRemainder(dividingBy: 1) < 0.1){
            return ("\(Int(num))")
        }
        return ("\(num)")
    }
}

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
