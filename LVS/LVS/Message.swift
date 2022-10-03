//
//  Messag.swift
//  LVS
//
//  Created by Jalal on 12/15/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class MessageList: NSObject {
    private static var instance : MessageList!
    
    public let messages: [MessageHeader]
    
    private init(messages: [MessageHeader]) {
        self.messages = messages
    }
    
    override init() {
        self.messages = [MessageHeader]()
    }
    
    class func getInstance() -> MessageList
    {
        if instance == nil
        {
            instance = MessageList()
        }
        return instance
    }
    
    func getMessages() -> [MessageHeader] {
        return self.messages
    }
    
    class func buildInstance(data: NSArray)
    {
        var messages: [MessageHeader] = [MessageHeader]()
        for item in data {
            let dictionary = item as! NSDictionary
            let MessageID = dictionary["MessageId"] as! String
            let Title = dictionary["Title"] as! String
            let MessageDate = dictionary["MessageDate"] as! String
            let SenderTitle = dictionary["SenderTitle"] as! String
            let HasAttachments = dictionary["HasAttachments"] as! Bool
            let IsRead = dictionary["IsRead"] as! Bool
            
            messages.append(MessageHeader(MessageID: MessageID, Title: Title, MessageDate: MessageDate, SenderTitle: SenderTitle, HasAttachments: HasAttachments, IsRead: IsRead))
        }
        
        instance = MessageList(messages: messages)
        
    }
    
    class func destroyInstance()
    {
        instance = nil
    }
}

class MessageHeader: NSObject {
    var MessageID: String
    var Title: String
    var MessageDate: String
    var SenderTitle: String
    var HasAttachments: Bool
    var IsRead: Bool
    
    init(MessageID: String, Title: String, MessageDate: String, SenderTitle: String, HasAttachments: Bool, IsRead: Bool) {
        self.MessageID = MessageID
        self.Title = Title
        self.MessageDate = MessageDate
        self.SenderTitle = SenderTitle
        self.HasAttachments = HasAttachments
        self.IsRead = IsRead
    }
}

