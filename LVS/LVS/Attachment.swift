//
//  Attachment.swift
//  LVS
//
//  Created by Jalal on 12/17/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class AttachmentList: NSObject {
    private static var instance : AttachmentList!
    
    public let attachments: [Attachment]
    
    private init(attachments: [Attachment]) {
        self.attachments = attachments
    }
    
    private override init() {
        self.attachments = [Attachment]()
    }
    
    class func getInstance() -> AttachmentList
    {
        if instance != nil
        {
            return instance
        }
        else
        {
            return AttachmentList()
        }
    }
    
    func getAttachments() -> [Attachment] {
        return self.attachments
    }
    
    class func buildInstance(data: NSArray)
    {
        var attachments: [Attachment] = [Attachment]()
        
        for item in data {
            let dictionary = item as! NSDictionary
            let FileName = dictionary["FileName"] as! String
            let FilePath = dictionary["FilePath"] as! String
            let FileSize = dictionary["FileSize"] as! String
            let FileType = dictionary["FileType"] as! String
            
            attachments.append(Attachment(FileName: FileName, FilePath: FilePath, FileSize: FileSize, FileType: FileType))
        }
        
        instance = AttachmentList(attachments: attachments)
        
    }
    
    class func destroyInstance()
    {
        instance = nil
    }
}

class Attachment: NSObject {
    var FileName: String
    var FilePath: String
    var FileSize: String
    var FileType: String
    
    init(FileName: String, FilePath: String, FileSize: String, FileType: String) {
        self.FileName = FileName
        self.FilePath = FilePath
        self.FileSize = FileSize
        self.FileType = FileType
    }
}
