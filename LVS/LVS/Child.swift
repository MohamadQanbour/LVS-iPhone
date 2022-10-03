//
//  Child.swift
//  LVS
//
//  Created by Jalal on 12/15/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class Children: NSObject {
    private static var instance : Children!
    
    public let children: [Child]
    
    private init(children: [Child]) {
        self.children = children
    }
    
    override init() {
        self.children = [Child]()
    }
    
    class func getInstance() -> Children
    {
        if instance == nil
        {
            instance = Children()
        }
        return instance
    }

    func getChildren() -> [Child] {
        return self.children
    }
    
    func getChaildrenString() -> String
    {
        var result = ""
        var i = 0
        
        for item in children {
            if i == 0
            {
                result = item.fullName
            }
            else
            {
                result = result + ", " + item.fullName
            }
            i += 1
        }
        return result
    }
    
    class func buildInstance(data: NSArray)
    {
        var children: [Child] = [Child]()
        
        for item in data {
            let dictionary = item as! NSDictionary
            let accessToken = dictionary["AccessToken"] as! String
            let fullName = dictionary["FullName"] as! String
            let username = dictionary["UserName"] as! String
            children.append(Child(accessToken: accessToken, fullName: fullName, userName: username))
        }
        
        instance = Children(children: children)
    }
}

class Child: NSObject {
    var accessToken : String
    var fullName : String
    var userName : String
    
    init(accessToken: String, fullName: String, userName: String) {
        self.accessToken = accessToken
        self.fullName = fullName
        self.userName = userName
    }
    
    /*required convenience init(coder aDecoder: NSCoder) {
        let accessToken = aDecoder.decodeObject(forKey: "accessToken") as! String
        let fullName = aDecoder.decodeObject(forKey: "fullName") as! String
        let userName = aDecoder.decodeObject(forKey: "userName") as! String
        
        self.init(accessToken: accessToken, fullName: fullName, userName: userName)
        
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.accessToken, forKey: "accessToken")
        aCoder.encode(self.fullName, forKey: "fullName")
        aCoder.encode(self.userName, forKey: "userName")
    
    }*/
    
}
