//
//  Teacher.swift
//  LVS
//
//  Created by Jalal on 12/27/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class TeacherList: NSObject {
    private static var instance : TeacherList!
    
    public let teachers: [Teacher]
    
    private init(teachers: [Teacher]) {
        self.teachers = teachers
    }
    
    private override init() {
        self.teachers = [Teacher]()
    }
    
    class func getInstance() -> TeacherList
    {
        if instance != nil
        {
            return instance
        }
        else
        {
            return TeacherList()
        }
    }
    
    func getTeachers() -> [Teacher] {
        return self.teachers
    }
    
    class func buildInstance(data: NSArray)
    {
        var teachers: [Teacher] = [Teacher]()
        
        for item in data {
            let dictionary = item as! NSDictionary
            let TeacherName = dictionary["TeacherName"] as! String
            let Materials = dictionary["Materials"] as! [String]
            
            
            teachers.append(Teacher(TeacherName: TeacherName, Materials: Materials))
        }
        
        instance = TeacherList(teachers: teachers)
        
    }
    
    class func destroyInstance()
    {
        instance = nil
    }
}

class Teacher: NSObject {
    var TeacherName: String
    var Materials: [String]
    
    init(TeacherName: String, Materials: [String]) {
        
        self.TeacherName = TeacherName
        self.Materials = Materials
        
    }
    
    func getMaterialsString() -> String {
        
        var i = 0
        var resultString = ""
        
        for material in Materials {
            if i == 0
            {
                resultString = resultString + material
            }
            else
            {
                resultString = resultString + ", " + material
            }
            i += 1
        }
        return resultString
        
    }
    
}

