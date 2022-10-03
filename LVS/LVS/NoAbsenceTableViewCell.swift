//
//  NoAbsenceTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/27/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class NoAbsenceTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = Colors.getInstance().colorBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
