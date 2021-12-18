//
//  OrganizationTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import UIKit

class OrganizationTableViewCell: UITableViewCell, ReusableTableViewCell {
    
    static let reuseIdentifier = "OrganizationTableViewCell"
    static var nib: UINib { return UINib(nibName: "OrganizationTableViewCell", bundle: nil) }
    
    @IBOutlet weak var avatarImageView: AsyncUIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.cornerRadius = 32.0
        avatarImageView.cornerCurve = .continuous
        avatarImageView.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        avatarImageView.cancel()
        loginLabel.text = nil
    }
    
    func configure<Type: Model>(with model: Type, completion: @escaping (NetworkError?) -> Void) {
        let organization = model as! OrganizationModel
        avatarImageView.load(at: organization.avatarURL) { networkError in print(networkError) }
        loginLabel.text = organization.login
        setNeedsLayout()
    }

}
