//
//  Administrative.swift
//  LVS
//
//  Created by Jalal on 12/27/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit


class StaffList: NSObject {
    private static var instance : StaffList!
    
    public let staff: [Administrative]
    
    private init(staff: [Administrative]) {
        self.staff = staff
    }
    
    private override init() {
        self.staff = [Administrative]()
    }
    
    class func getInstance() -> StaffList
    {
        if instance != nil
        {
            return instance
        }
        else
        {
            return StaffList()
        }
    }
    
    func getStaff() -> [Administrative] {
        return self.staff
    }
    
    class func buildInstance(data: NSArray)
    {
        let lang = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String
        
        var staffs: [Administrative] = [Administrative]()
        
        for item in data {
            
            let dictionary = item as! NSDictionary
            var RoleName: String
            
            if lang == "ar"
            {
                let Name = dictionary["RoleName"] as! String
                
                let range: Range<String.Index> = Name.range(of: "|")!
                
                RoleName = String(Name[range.upperBound...])
                
                
                
                RoleName = RoleName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
            }
            else
            {
                let Name = dictionary["RoleName"] as! String
                
                let range: Range<String.Index> = Name.range(of: "|")!
                                
                RoleName = String(Name[..<range.lowerBound])
                
                RoleName = RoleName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            
            let staff = dictionary["Staff"] as! [String]
            
            
            staffs.append(Administrative(RoleName: RoleName, staff: staff))
        }
        
        instance = StaffList(staff: staffs)
        
    }
    
    class func destroyInstance()
    {
        instance = nil
    }
}

class Administrative: NSObject {
    var RoleName: String
    var staff: [String]
    
    init(RoleName: String, staff: [String]) {
        
        self.RoleName = RoleName
        self.staff = staff
        
    }
    
    func getStaffString() -> String {
        
        var i = 0
        var resultString = ""
        
        for item in staff {
            if i == 0
            {
                resultString = resultString + item
            }
            else
            {
                resultString = resultString + ", " + item
            }
            i += 1
        }
        return resultString
        
    }
}

