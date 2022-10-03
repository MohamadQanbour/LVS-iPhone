//
//  NoteTableViewCell.swift
//  LVS
//
//  Created by Jalal on 12/24/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    var note: Note! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var noteText: UILabel!
    
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
            noteText.textAlignment = .right
        }
        
        sender.adjustsFontSizeToFitWidth = true
        date.adjustsFontSizeToFitWidth = true
        
        sender.text = note.SenderName
        date.text = note.NoteDate
        noteText.text = note.NoteText
        
        self.noteText.frame = CGRect(x: 70 , y: 90 , width: self.noteText.frame.width , height: CGFloat.leastNormalMagnitude )
        self.noteText.numberOfLines = 0
        self.noteText.lineBreakMode = .byWordWrapping
              
        self.backgroundCardView.setNeedsLayout()
        
        self.backgroundCardView.layoutIfNeeded()
        self.backgroundCardView.layoutSubviews()
        
        if note.NoteType == 1
        {
            backgroundCardView.backgroundColor = Colors.getInstance().colorNegative
        }
        else
        {
            backgroundCardView.backgroundColor = Colors.getInstance().colorPositive
        }
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }

}
