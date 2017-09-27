//
//  ContactListTableViewCell.swift
//  Code Test Miguel Roncallo
//
//  Created by Miguel Roncallo on 9/25/17.
//  Copyright © 2017 Miguel Roncallo. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    
    @IBOutlet weak var contactNumberLabel: UILabel!
    
    @IBOutlet weak var contactEmailLabel: UILabel!
    
    static let cellIdentifier = "ContactListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
