//
//  AttachmentCell.swift
//  LVS
//
//  Created by Jalal on 12/17/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class AttachmentCell: UICollectionViewCell {
    
    var attachment: Attachment! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    func updateUI()
    {
        name.adjustsFontSizeToFitWidth = true
        
        name.text = attachment.FileName
        
        
        let range: Range<String.Index> = attachment.FileName.range(of: ".")!
        
        var fileType = String(attachment.FileName[range.upperBound...])
        
        fileType = fileType.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        icon.image = UIImage(named: fileType)
        
        backgroundCardView.backgroundColor = Colors.getInstance().colorBackgroundLight
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }

}
