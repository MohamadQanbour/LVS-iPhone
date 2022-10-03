//
//  User.swift
//  LVS
//
//  Created by Jalal on 12/11/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import Foundation

class User: NSObject {
    private static var instance : User!
    public let Token: String
    public let userType: Int
    public let fullName: String
    public let email: String
    
    private init(token: String, type:Int, fullName: String, email: String) {
        self.Token = token
        self.userType = type
        self.fullName = fullName
        self.email = email
    }
    
    override init() {
        self.Token = String()
        self.userType = Int()
        self.fullName = String()
        self.email = String()
    }
        
    class func buildInstance(token: String, type:Int, fullName: String, email: String)
    {
        instance = User(token: token, type: type, fullName: fullName, email: email)
    }
    
    class func getInstance() -> User
    {
        if instance == nil
        {
            instance = User()
        }
        return instance
    }


}
