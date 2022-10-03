//
//  StaffTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/28/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

struct Staff {
    var Name: String
    var Contenet: String
    var isLast: Bool
}

class StaffTableViewCell: UITableViewCell {

    var staff: Staff! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var Separetor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //
    }
    
    func updateUI()
    {
        Name.textColor = Colors.getInstance().colorPrimary
        
        Name.text = staff.Name
        Content.text = staff.Contenet
        
        if staff.isLast
        {
            Separetor.isHidden = true
        }
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        self.Content.lineBreakMode = .byWordWrapping
        
    }

}
