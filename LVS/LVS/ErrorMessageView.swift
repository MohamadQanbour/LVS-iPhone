//
//  ErrorMessageView.swift
//  LVS
//
//  Created by Jalal on 1/5/17.
//  Copyright © 2017 Abd Al Majed. All rights reserved.
//

import UIKit

class ErrorMessageView: UIView {

    
    func draw(x: CGFloat, y: CGFloat, width: CGFloat, message: String) {
        
        self.frame = CGRect(x: x, y: y, width: width, height: 30.0)
        let messageLabel = UILabel(frame: CGRect(x: 4, y: 0, width: width - 8, height: 30.0))
        
        self.layer.cornerRadius = 10.0
        
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        
        messageLabel.layer.cornerRadius = 10.0
        messageLabel.textAlignment = .center
        messageLabel.textColor = UIColor.white
        messageLabel.text = message
        messageLabel.adjustsFontSizeToFitWidth = true
        
        self.addSubview(messageLabel)
    }

}
