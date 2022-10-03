//
//  ExamCollectionViewCell.swift
//  LVS
//
//  Created by Jalal on 12/24/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class ExamCollectionViewCell: UICollectionViewCell {
    
    var exam: Exam! {
        didSet {
            self.updateUI()
        }
    }
    
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var examTitle: InsetLabel!
    @IBOutlet weak var examMark: UILabel!
    
    func updateUI()
    {
        examTitle.adjustsFontSizeToFitWidth = true
        examMark.adjustsFontSizeToFitWidth = true
        
        examTitle.textColor = UIColor.white
        
        examTitle.text = exam.ExamTitle
        examMark.text = exam.ExamMark
        
        print(examTitle.alignmentRectInsets)
        
        backgroundCardView.backgroundColor = UIColor.lightGray
        
        contentView.backgroundColor = Colors.getInstance().colorBackgroundLight
        
        backgroundCardView.layer.cornerRadius = 4.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }
    
}
