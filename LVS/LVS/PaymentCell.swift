//
//  PaymentTableViewCell.swift
//  LVS
//
//  Created by Jalal on 1/7/17.
//  Copyright © 2017 Abd Al Majed. All rights reserved.
//

import UIKit

struct PaymentData {
    var No: String
    var Value: String
    var Date: String
}

class PaymentTableViewCell: UITableViewCell {

    var paymentData: PaymentData! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var No: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var no_width: NSLayoutConstraint!
    @IBOutlet weak var value_width: NSLayoutConstraint!
    @IBOutlet weak var date_width: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI()
    {
        No.adjustsFontSizeToFitWidth = true
        value.adjustsFontSizeToFitWidth = true
        date.adjustsFontSizeToFitWidth = true
        
        no_width.constant = (41.0 / 343.0) * self.frame.width
        value_width.constant = (121.0 / 343.0) * self.frame.width
        date_width.constant = (181.0 / 343.0) * self.frame.width
        
        let insets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        self.No.drawText(in: self.No.frame.inset(by: insets))
        self.value.drawText(in: self.No.frame.inset(by: insets))
        self.date.drawText(in: self.No.frame.inset(by: insets))
        
        No.text = paymentData.No
        value.text = paymentData.Value
        date.text = paymentData.Date
        
        No.layer.borderWidth = 1.0
        No.layer.borderColor = Colors.getInstance().colorPrimary.cgColor
        
        value.layer.borderWidth = 1.0
        value.layer.borderColor = Colors.getInstance().colorPrimary.cgColor
        
        date.layer.borderWidth = 1.0
        date.layer.borderColor = Colors.getInstance().colorPrimary.cgColor
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
    }

}
