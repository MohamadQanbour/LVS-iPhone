//
//  MaterialMark.swift
//  LVS
//
//  Created by Jalal on 12/24/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class MarkList: NSObject {
    private static var instance : MarkList!
    
    public let marks: [MaterialMark]
    
    private init(marks: [MaterialMark]) {
        self.marks = marks
    }
    
    private override init() {
        self.marks = [MaterialMark]()
    }
    
    class func getInstance() -> MarkList
    {
        if instance != nil
        {
            return instance
        }
        else
        {
            return MarkList()
        }
    }
    
    func getMarks() -> [MaterialMark] {
        return self.marks
    }
    
    class func buildInstance(data: NSArray)
    {
        var marks: [MaterialMark] = [MaterialMark]()
        
        for item in data {
            let dictionary = item as! NSDictionary
            
            let MaterialId = dictionary["MaterialId"] as! Int
            let MaterialTitle = dictionary["MaterialTitle"] as! String
            let MaterialMaxMark = dictionary["MaterialMaxMark"] as! Int
            let ExamsData = dictionary["Exams"] as! NSArray
            let Exams = ExamList(data: ExamsData).exams
            
            marks.append(MaterialMark(MaterialId: MaterialId, MaterialTitle: MaterialTitle, MaterialMaxMark: MaterialMaxMark, Exams: Exams))
        }
        
        instance = MarkList(marks: marks)
        
    }
    
    class func destroyInstance()
    {
        instance = nil
    }
}

class MaterialMark: NSObject {
    var MaterialId: Int
    var MaterialTitle: String
    var MaterialMaxMark: Int
    var Exams: [Exam]
    
    init(MaterialId: Int, MaterialTitle: String, MaterialMaxMark: Int, Exams: [Exam]) {
        
        self.MaterialId = MaterialId
        self.MaterialTitle = MaterialTitle
        self.MaterialMaxMark = MaterialMaxMark
        self.Exams = Exams
        
    }

}
