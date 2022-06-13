//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by 1606085 on 27/03/22.
//

import Foundation
import UIKit
protocol ContactTableViewDelegate{
    func performPhotoView(cell:ContactTableViewCell)
}
class ContactTableViewCell:UITableViewCell{
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var name: UILabel!
    var delegate:ContactTableViewDelegate?
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
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(self.performPhotoSelection(_:)))
        tapgesture.delegate = self
        profile.addGestureRecognizer(tapgesture)
        
        
    }
    @objc func performPhotoSelection(_:UITapGestureRecognizer){
        delegate?.performPhotoView(cell:self)
    }
   
}
