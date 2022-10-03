//
//  NoNotesCell.swift
//  LVS
//
//  Created by Jalal on 2/15/17.
//  Copyright © 2017 Abd Al Majed. All rights reserved.
//

import UIKit

class NoNotesCell: UITableViewCell {

    @IBOutlet weak var noNotes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        noNotes.text = NSLocalizedString("no_notes", comment: "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
