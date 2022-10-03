//
//  HomeTableViewCell2.swift
//  LVS
//
//  Created by Jalal on 12/25/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class HomeTableViewCell2: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mark: UILabel!
    
    @IBOutlet weak var marks: UITableView!
    
    var marksList = [MaterialMark]()
    var downloadingMarks = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.marks.delegate = self
        self.marks.dataSource = self
        
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        mark.text = NSLocalizedString("marks", comment: "")
        mark.textColor = UIColor.white
        mark.backgroundColor = Colors.getInstance().colorPrimary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func refresh() {
        
        self.marks.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.marksList.count > 0
        {
            return self.marksList.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.marksList.count > 0
        {
            let mark = self.marksList[(indexPath as NSIndexPath).row]
            if mark.Exams.count / 3 > 0
            {
                if mark.Exams.count % 3 != 0
                {
                    return CGFloat(166) + CGFloat(mark.Exams.count / 3) * 105.5
                    
                }
                else
                {
                    return CGFloat(166) + CGFloat((mark.Exams.count / 3) - 1) * 105.5
                }
            }
            else
            {
                if mark.Exams.count > 0
                {
                    return CGFloat(166)
                }
                else
                {
                    return CGFloat(43)
                }
            }
            
        }
        else
        {
            return CGFloat(41)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.marksList.count > 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mark Cell", for: indexPath) as! MarkTableViewCell
            let mark = self.marksList[(indexPath as NSIndexPath).row]
            
            cell.mark = mark
            
            cell.refresh()
            
            return cell
        }
        else
        {
            if !downloadingMarks
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "No Mark Cell", for: indexPath)
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Downloading Marks Cell", for: indexPath) as! DownloadingMarksTableViewCell
                
                cell.refresh()
                return cell
            }
        }
        
    }

}
