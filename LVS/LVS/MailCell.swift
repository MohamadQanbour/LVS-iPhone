//
//  MailTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/15/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class MailTableViewCell: UITableViewCell {
    
    var message: MessageHeader! {
        didSet {
            self.updateUI()
        }
    }

    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI()
    {
        if (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String == "ar"
        {
            date.textAlignment = .left
            sender.textAlignment = .right
            title.textAlignment = .right
        }
        
        date.textColor = Colors.getInstance().colorPrimary
        
        sender.adjustsFontSizeToFitWidth = true
        date.adjustsFontSizeToFitWidth = true
        title.adjustsFontSizeToFitWidth = true
        
        sender.text = message.SenderTitle
        date.text = message.MessageDate
        title.text = message.Title
        
        if message.HasAttachments
        {
            icon.isHidden = false
        }
        
        
        if message.IsRead
        {
            backgroundCardView.backgroundColor = Colors.getInstance().colorBackgroundLight
        }
        else
        {
            backgroundCardView.backgroundColor = Colors.getInstance().colorBackgroundDark
        }
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }

}
