//
//  Note.swift
//  LVS
//
//  Created by Jalal on 12/24/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class NoteList: NSObject {
    private static var instance : NoteList!
    
    public let notes: [Note]
    
    private init(notes: [Note]) {
        self.notes = notes
    }
    
    private override init() {
        self.notes = [Note]()
    }
    
    class func getInstance() -> NoteList
    {
        if instance != nil
        {
            return instance
        }
        else
        {
            return NoteList()
        }
    }
    
    func getNotes() -> [Note] {
        return self.notes
    }
    
    class func buildInstance(data: NSArray)
    {
        var notes: [Note] = [Note]()
        
        for item in data {
            let dictionary = item as! NSDictionary
            let Id = dictionary["Id"] as! Int
            let SenderId = dictionary["SenderId"] as! Int
            let SenderName = dictionary["SenderName"] as! String
            let StudentId = dictionary["StudentId"] as! Int
            let StudentSchoolId = dictionary["StudentSchoolId"] as! String
            let StudentName = dictionary["StudentName"] as! String
            let NoteType = dictionary["NoteType"] as! Int
            let NoteDate = dictionary["NoteDate"] as! String
            let NoteText = dictionary["NoteText"] as! String
            
            notes.append(Note(Id: Id, SenderId: SenderId, SenderName: SenderName, StudentId: StudentId, StudentSchoolId: StudentSchoolId, StudentName: StudentName, NoteType: NoteType, NoteDate: NoteDate, NoteText: NoteText))
        }
        
        instance = NoteList(notes: notes)
        
    }
    
    class func destroyInstance()
    {
        instance = nil
    }
}

class Note: NSObject {
    var Id: Int
    var SenderId: Int
    var SenderName: String
    var StudentId: Int
    var StudentSchoolId: String
    var StudentName: String
    var NoteType: Int
    var NoteDate: String
    var NoteText: String
    
    init(Id: Int, SenderId: Int, SenderName: String, StudentId: Int, StudentSchoolId: String, StudentName: String, NoteType: Int, NoteDate: String, NoteText: String) {
        
        self.Id = Id
        self.SenderId = SenderId
        self.SenderName = SenderName
        self.StudentId = StudentId
        self.StudentSchoolId = StudentSchoolId
        self.StudentName = StudentName
        self.NoteType = NoteType
        self.NoteDate = NoteDate
        self.NoteText = NoteText
        
    }

}



