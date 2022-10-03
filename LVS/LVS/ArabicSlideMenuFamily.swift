//
//  ArabicSlideMenuFamily.swift
//  LVS
//
//  Created by Jalal on 12/29/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class ArabicSlideMenuFamily: UITableViewController {

    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var studentsName: UILabel!
    
    @IBOutlet weak var home: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var marks: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var payments: UILabel!
    @IBOutlet weak var teaching_staff: UILabel!
    @IBOutlet weak var administrative_staff: UILabel!
    @IBOutlet weak var call_us: UILabel!
    @IBOutlet weak var about_us: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var logout: UILabel!
    
    @IBOutlet weak var unreadMailsCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        familyName.text = User.getInstance().fullName
        familyName.textColor = UIColor.white
        
        studentsName.text = Children.getInstance().getChaildrenString()
        studentsName.textColor = UIColor.white

        home.text = "الرئيسية"
        mail.text = "البريد"
        marks.text = "العلامات"
        notes.text = "الملاحظات"
        payments.text = "الأقساط"
        teaching_staff.text = "الكادر التدريسي"
        administrative_staff.text = "الكادر الإداري"
        call_us.text = "اتصل بنا"
        about_us.text = "حول"
        profile.text = "الحساب الشخصي"
        logout.text = "تسجيل الخروج"
        
        unreadMailsCount.textColor = Colors.getInstance().colorPrimary

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
                UserDefaults.standard.removeObject(forKey: "ActiveName")
            }
        }
    }
    

}
