//
//  DownloadingAbsencesTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/27/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class DownloadingAbsencesTableViewCell: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = Colors.getInstance().colorBackground
        self.indicator.color = Colors.getInstance().colorAccent
        indicator.startAnimating()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refresh()
    {
        indicator.startAnimating()
    }

}
