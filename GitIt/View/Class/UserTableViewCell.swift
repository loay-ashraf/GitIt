//
//  UserTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 24/10/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell, ReusableTableViewCell {
    
    static let reuseIdentifier = "UserTableViewCell"
    static var nib: UINib { return UINib(nibName: "UserTableViewCell", bundle: nil) }
    
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var userImageView: AsyncUIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.cornerRadius = 32.0
        userImageView.cornerCurve = .continuous
        userImageView.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userLoginLabel.text = nil
        userImageView.image = nil
        userImageView.cancel()
    }
    
    func configure<Type: Model>(with model: Type) {
        let user = model as! UserModel
        userLoginLabel.text = user.login
        userImageView.load(at: user.avatarURL)
        setNeedsLayout()
    }

}
