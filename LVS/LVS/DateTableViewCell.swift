//
//  DateTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/27/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    var dateValue: String! {
        didSet {
            self.updateUI()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI()
    {
        dateLabel.text = dateValue
        dateLabel.backgroundColor = UIColor.white
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        dateLabel.layer.cornerRadius = 3.0
        dateLabel.layer.masksToBounds = false
        
        dateLabel.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        dateLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        dateLabel.layer.shadowOpacity = 0.8
        
    }

}
