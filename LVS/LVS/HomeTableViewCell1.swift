//
//  HomeTableViewCell1.swift
//  LVS
//
//  Created by Jalal on 12/25/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class HomeTableViewCell1: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var newEmails: UILabel!
        
    @IBOutlet weak var newMails: UITableView!
    var messagesList = [MessageHeader]()
    var downloadingMails = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.newMails.delegate = self
        self.newMails.dataSource = self
        
        // Initialization code
        contentView.backgroundColor = Colors.getInstance().colorBackground
        
        newEmails.text = NSLocalizedString("new_emails", comment: "")
        newEmails.textColor = UIColor.white
        newEmails.backgroundColor = Colors.getInstance().colorPrimary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func refresh() {
        
        self.newMails.reloadData()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.messagesList.count > 0
        {
            return self.messagesList.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if messagesList.count > 0
        {
            return CGFloat(133)
        }
        else
        {
            return CGFloat(41)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.messagesList.count > 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mail Cell", for: indexPath) as! MailTableViewCell
            let message = self.messagesList[(indexPath as NSIndexPath).row]
            
            cell.message = message
            
            return cell
        }
        else
        {
            if !downloadingMails
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "No Mail Cell", for: indexPath)
            
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Downloading Mails Cell", for: indexPath) as! DownloadingMailsTableViewCell
                
                cell.refresh()
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.messagesList[indexPath.row].IsRead = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowEmail"), object: indexPath)
        
    }
    
    

}
