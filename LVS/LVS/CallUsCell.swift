//
//  CallUsTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/31/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class CallUsTableViewCell: UITableViewCell {
    
    var contact: Contact! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var separator1: NSLayoutConstraint!

    @IBOutlet weak var separator2: NSLayoutConstraint!
    
    @IBOutlet weak var separator3: NSLayoutConstraint!
    
    @IBOutlet weak var separator4: NSLayoutConstraint!
    
    @IBOutlet weak var separator5: NSLayoutConstraint!
    
    @IBOutlet weak var deptName: UILabel!
    
    @IBOutlet weak var mobile: UILabel!
    
    @IBOutlet weak var dash: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var phoneLength: NSLayoutConstraint!
    @IBOutlet weak var dashLength: NSLayoutConstraint!
    @IBOutlet weak var mobileLength: NSLayoutConstraint!
    @IBOutlet weak var nameLength: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI()
    {
        deptName.textColor = UIColor.blue
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        deptName.adjustsFontSizeToFitWidth = true
        mobile.adjustsFontSizeToFitWidth = true
        dash.adjustsFontSizeToFitWidth = true
        phone.adjustsFontSizeToFitWidth = true
        
        deptName.text = contact.depName
        mobile.text = contact.mobile
        dash.text = contact.dash
        phone.text = contact.phone
        
        deptName.textColor = Colors.getInstance().colorPrimary
        
        nameLength.constant = (90.0 / 280.0) * (self.frame.width - 40.0)
        mobileLength.constant = (123.0 / 280.0) * (self.frame.width - 40.0)
        dashLength.constant = (12.0 / 280.0) * (self.frame.width - 40.0)
        phoneLength.constant = (66.0 / 280.0) * (self.frame.width - 40.0)
        
        let mobileTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.call(_:)))
        
        self.mobile.addGestureRecognizer(mobileTap)
        
        let phoneTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.call(_:)))
        
        self.phone.addGestureRecognizer(phoneTap)
        
        /*let separator = (8.0 / 320.0) * self.frame.width
        
        separator1.constant = separator
        separator2.constant = separator
        separator3.constant = separator
        separator4.constant = separator
        separator5.constant = separator*/
        
        phone.textAlignment = NSTextAlignment.center
        dash.textAlignment = NSTextAlignment.center
        mobile.textAlignment = NSTextAlignment.center
        deptName.textAlignment = NSTextAlignment.right
        
        /*if self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.leftToRight
        {
            phone.frame = CGRect(x: separator, y: 8, width: phoneWidth, height: phone.frame.height)
            dash.frame = CGRect(x: 2 * separator + phoneWidth, y: 8, width: dashWidth, height: dash.frame.height)
            mobile.frame = CGRect(x: 3 * separator + phoneWidth + dashWidth, y: 8, width: mobWidth, height: mobile.frame.height)
            deptName.frame = CGRect(x: 4 * separator + phoneWidth + dashWidth + mobWidth, y: 8, width: deptWidth, height: deptName.frame.height)
            
            
        }
        else if self.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.rightToLeft
        {
            deptName.frame = CGRect(x: separator, y: 8, width: deptWidth, height: deptName.frame.height)
            mobile.frame = CGRect(x: 2 * separator + deptWidth, y: 8, width: mobWidth, height: mobile.frame.height)
            dash.frame = CGRect(x: 3 * separator + deptWidth + mobWidth, y: 8, width: dashWidth, height: dash.frame.height)
            phone.frame = CGRect(x: 4 * separator + deptWidth + mobWidth + dashWidth, y: 8, width: phoneWidth, height: phone.frame.height)
        }*/
        
    }
    
    @objc func call(_ sender: UITapGestureRecognizer)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Call"), object: sender.view)
        
    }
    
}
