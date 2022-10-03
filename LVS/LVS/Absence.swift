//
//  Absence.swift
//  LVS
//
//  Created by Jalal on 12/27/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class Absence: NSObject {
    private static var instance : Absence!
    
    public let dates: [String]
    public let presentDays: Int
    public let absencesDays: Int
    
    private init(dates: [String], presentDays: Int, absencesDays: Int) {
        self.dates = dates
        self.presentDays = presentDays
        self.absencesDays = absencesDays
    }
    
    private override init() {
        self.dates = [String]()
        self.presentDays = 0
        self.absencesDays = 0
    }
    
    class func getInstance() -> Absence
    {
        if instance != nil
        {
            return instance
        }
        else
        {
            return Absence()
        }
    }
    
    func getDates() -> [String] {
        return self.dates
    }
    
    class func buildInstance(data: NSDictionary)
    {
        let presentDays = data["PresentDays"] as! Int
        let absencesDays = data["AbsentDays"] as! Int
        
        let datesData = data["AbsentDates"] as! NSArray
        
        var dates: [String] = [String]()
        
        for item in datesData {
            let date = item as! String
            
            dates.append(date)
        }
        
        instance = Absence(dates: dates, presentDays: presentDays, absencesDays: absencesDays)
        
    }

}
