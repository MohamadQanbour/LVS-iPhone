//
//  TableViewController2.swift
//  LVS
//
//  Created by Jalal on 12/13/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class EnglishSlideMenuStudent: UITableViewController {

    @IBOutlet weak var unreadMailsCount: UILabel!
    
    @IBOutlet weak var studentName: UILabel!
    
    @IBOutlet weak var LVS: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        studentName.text = User.getInstance().fullName
        studentName.textColor = UIColor.white
        
        unreadMailsCount.textColor = Colors.getInstance().colorPrimary
        
        LVS.adjustsFontSizeToFitWidth = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "UnreadMailsCount") != nil{
            unreadMailsCount.text = "\(UserDefaults.standard.value(forKey: "UnreadMailsCount") as! Int)"
        }
        else
        {
            unreadMailsCount.text = "0"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout"
        {
            if UserDefaults.standard.value(forKey: "Token") != nil
            {
                let token = UserDefaults.standard.value(forKey: "Token") as? String
                
                let userID = UserDefaults.standard.value(forKey: "deviceID") as? String
                
                Request.getInstance().requestService(object: self, model: "Membership", task: "UnregisterDevice", getParameters: ["access_token": token!, "device_token": userID!], postParameters: [String: String]())
                
                UserDefaults.standard.removeObject(forKey: "Token")
                UserDefaults.standard.removeObject(forKey: "Type")
                UserDefaults.standard.removeObject(forKey: "FullName")
                UserDefaults.standard.removeObject(forKey: "Email")
                UserDefaults.standard.removeObject(forKey: "UnreadMailsCount")
                UserDefaults.standard.removeObject(forKey: "ActiveToken")
            }
            
        }
    }
}
