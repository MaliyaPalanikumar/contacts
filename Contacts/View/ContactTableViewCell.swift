//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by 1606085 on 27/03/22.
//

import Foundation
import UIKit
class ContactTableViewCell:UITableViewCell{
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var name: UILabel!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        profile.layer.cornerRadius = profile.frame.size.width / 2
        profile.clipsToBounds = true
        profile.layer.borderWidth = 3.0
        profile.layer.masksToBounds = true
        profile.layer.borderColor = UIColor.clear.cgColor
        
    }
   
}
