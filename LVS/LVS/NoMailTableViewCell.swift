//
//  NoMailTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/25/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class NoMailTableViewCell: UITableViewCell {

    @IBOutlet weak var noMail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        noMail.text = NSLocalizedString("no_mails", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
