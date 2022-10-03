//
//  DownloadingMarksTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/25/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class DownloadingMarksTableViewCell: UITableViewCell {

    @IBOutlet weak var indictor: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        self.indictor.color = Colors.getInstance().colorAccent
        indictor.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refresh()
    {
        indictor.startAnimating()
    }

}
