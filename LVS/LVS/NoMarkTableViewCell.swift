//
//  NoMarkTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/25/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class NoMarkTableViewCell: UITableViewCell {

    @IBOutlet weak var noMarks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        noMarks.text = NSLocalizedString("no_marks", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
