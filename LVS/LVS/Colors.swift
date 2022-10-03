//
//  Colors.swift
//  LVS
//
//  Created by Jalal on 1/3/17.
//  Copyright © 2017 Abd Al Majed. All rights reserved.
//

import UIKit

class Colors: NSObject {
    
    private static let instance : Colors = Colors()
    
    public var colorBackground: UIColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    
    public var colorBackgroundLight: UIColor = UIColor.white
    
    public var colorBackgroundDark: UIColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)
    
    public var colorPrimary: UIColor = UIColor(red: CGFloat(51.0 / 255.0), green: CGFloat(13.0 / 255.0), blue: CGFloat(108.0 / 255.0), alpha: CGFloat(1.0))
    
    public var colorPrimaryLight: UIColor = UIColor(red: CGFloat(70.0 / 255.0), green: CGFloat(24.0 / 255.0), blue: CGFloat(139.0 / 255.0), alpha: CGFloat(1.0))
    
    public var colorPrimaryDark: UIColor = UIColor(red: CGFloat(31.0 / 255.0), green: CGFloat(6.0 / 255.0), blue: CGFloat(69.0 / 255.0), alpha: CGFloat(1.0))
    
    public var colorAccent: UIColor = UIColor(red: CGFloat(255.0 / 255.0), green: CGFloat(64.0 / 255.0), blue: CGFloat(129.0 / 255.0), alpha: CGFloat(1.0))
    
    public var colorContract: UIColor = UIColor(red: CGFloat(214.0 / 255.0), green: CGFloat(217.0 / 255.0), blue: CGFloat(52.0 / 255.0), alpha: CGFloat(1.0))
    
    public var colorNegative: UIColor = UIColor(red: CGFloat(180.0 / 255.0), green: CGFloat(42.0 / 255.0), blue: CGFloat(42.0 / 255.0), alpha: CGFloat(1.0))
    
    public var colorPositive: UIColor = UIColor(red: CGFloat(44.0 / 255.0), green: CGFloat(151.0 / 255.0), blue: CGFloat(44.0 / 255.0), alpha: CGFloat(1.0))
    
    private override init() {
        
    }
    
    class func getInstance() -> Colors
    {
        return instance
    }

}
