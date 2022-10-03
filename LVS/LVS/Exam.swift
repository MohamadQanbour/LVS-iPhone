//
//  Exam.swift
//  LVS
//
//  Created by Jalal on 12/24/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class ExamList: NSObject {
    
    var exams: [Exam]
    
    init(data: NSArray)
    {
        self.exams = [Exam]()
        
        for item in data {
            let dictionary = item as! NSDictionary
            let ExamTitle = dictionary["ExamTitle"] as! String
            let ExamMark = dictionary["ExamMark"] as! String
            let ExamType = dictionary["ExamType"] as! Int
            let ExamMaxMark = dictionary["ExamMaxMark"] as! Int
            
            self.exams.append(Exam(ExamTitle: ExamTitle, ExamMark: ExamMark, ExamType: ExamType, ExamMaxMark: ExamMaxMark))
            
        }
        
    }
}

class Exam: NSObject {
    var ExamTitle: String
    var ExamMark: String
    var ExamType: Int
    var ExamMaxMark: Int
    
    init(ExamTitle: String, ExamMark: String, ExamType: Int, ExamMaxMark: Int) {
        
        self.ExamTitle = ExamTitle
        self.ExamMark = ExamMark
        self.ExamType = ExamType
        self.ExamMaxMark = ExamMaxMark
        
    }

}
