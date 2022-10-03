//
//  HomeTableViewCell3.swift
//  LVS
//
//  Created by Jalal on 12/25/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class HomeTableViewCell3: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var absence: UILabel!
    
    @IBOutlet weak var paresentDaysLable: UILabel!
    @IBOutlet weak var absenceDayLabel: UILabel!
    @IBOutlet weak var DaysLabel1: UILabel!
    @IBOutlet weak var DaysLabel2: UILabel!
    @IBOutlet weak var absentDays: UILabel!
    @IBOutlet weak var presentDays: UILabel!
    @IBOutlet weak var absenceDaysList: UITableView!
    
    var absenceDates = [String]()
    var downloadingDates = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.absenceDaysList.delegate = self
        self.absenceDaysList.dataSource = self
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        absence.text = NSLocalizedString("absence", comment: "")
        absence.textColor = UIColor.white
        absence.backgroundColor = Colors.getInstance().colorPrimary
        
        paresentDaysLable.text = NSLocalizedString("present_days", comment: "")
        absenceDayLabel.text = NSLocalizedString("absence_days", comment: "")
        
        DaysLabel1.text = NSLocalizedString("days", comment: "")
        DaysLabel2.text = NSLocalizedString("days", comment: "")
        
        absentDays.text = "\(Absence.getInstance().absencesDays)"
        presentDays.text = "\(Absence.getInstance().presentDays)"
        
        DaysLabel1.textColor = Colors.getInstance().colorPositive
        DaysLabel2.textColor = Colors.getInstance().colorNegative
        
        absentDays.textColor = Colors.getInstance().colorNegative
        presentDays.textColor = Colors.getInstance().colorPositive
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refresh() {
        
        absentDays.text = "\(Absence.getInstance().absencesDays)"
        presentDays.text = "\(Absence.getInstance().presentDays)"
        self.absenceDaysList.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.absenceDates.count > 0
        {
            return self.absenceDates.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if absenceDates.count > 0
        {
            return CGFloat(46)
        }
        else
        {
            if !downloadingDates
            {
                return CGFloat(0)
            }
            else
            {
                return CGFloat(41)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.absenceDates.count > 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Absence Cell", for: indexPath) as! DateTableViewCell
            let date = self.absenceDates[(indexPath as NSIndexPath).row]
            
            cell.dateValue = date
            
            return cell
        }
        else
        {
            if !downloadingDates
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "No Absence Cell", for: indexPath)
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Downloading Absences Cell", for: indexPath) as! DownloadingAbsencesTableViewCell
                
                cell.refresh()
                return cell
            }
        }
        
    }


}
