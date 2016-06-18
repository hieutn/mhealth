//
//  DoctorCell.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import UIKit
import SDWebImage

class DoctorCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func prepareForReuse() {
        fullNameLabel.text = ""
    }
    
    func configure(withDoctor doctor: Doctor) {
        fullNameLabel.text = doctor.name
        
        if let urlString = doctor.url?.URLEscapedString, let url = NSURL(string: urlString) {
            avatarImageView.sd_setImageWithURL(url)
        }
    }
    
}
