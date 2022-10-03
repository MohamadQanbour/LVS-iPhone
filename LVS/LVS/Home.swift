//
//  HomeViewController.swift
//  LVS
//
//  Created by Jalal on 12/12/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class Home: UITableViewController {

    @IBOutlet weak var showMenu: UIButton!
    @IBOutlet weak var chosenChild: UIButton!
    
    let cells = [1, 2, 3]
    
    var cell1: HomeTableViewCell1!
    var cell2: HomeTableViewCell2!
    var cell3: HomeTableViewCell3!
    var downloadingAbsences: Bool = true
    
    var messagesList = [MessageHeader]()
    var marksList = [MaterialMark]()
    var absentDatesList = [String]()
    
    var errorMessage: ErrorMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = NSLocalizedString("home", comment: "")
        
        if (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String == "ar"
        {
            showMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)), for: .touchUpInside)
            self.revealViewController().rearViewController = nil
        }
        else
        {
            showMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.revealViewController().rightViewController = nil
        }
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = Colors.getInstance().colorBackground
        
        NotificationCenter.default.addObserver(self , selector: #selector(Home.showEmailAction(_:)), name: NSNotification.Name(rawValue: "ShowEmail"), object: nil)
        
        self.chosenChild.isEnabled = true
        self.showMenu.isEnabled = true
        
        if User.getInstance().userType == 1
        {
            self.chosenChild.isEnabled = false
            self.chosenChild.isHidden = true
        }
        else if User.getInstance().userType == 2
        {
            let Name = UserDefaults.standard.value(forKey: "ActiveName") as! String
            self.chosenChild.setTitle(Name, for: .normal)
        }
        
        messagesList = [MessageHeader]()
        marksList = [MaterialMark]()
        absentDatesList = [String]()
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        Request.getInstance().requestService(object: self, model: "Scores", task: "GetCurrent", getParameters: ["access_token": Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "List", getParameters: ["access_token": User.getInstance().Token, "message_role": "2", "page_size": "3", "page_index": "0", "unread": "false", "new": "false"], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
        Request.getInstance().requestService(object: self, model: "Attendance", task: "GetAttendance", getParameters: ["access_token": Token], postParameters: [String: String]())

        if User.getInstance().userType == 2
        {
            Request.getInstance().requestService(object: self, model: "Membership", task: "Payments", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func enableViewWithRefresh() 
    {
        let Name = UserDefaults.standard.value(forKey: "ActiveName") as! String
        self.chosenChild.setTitle(Name, for: .normal)
        
        self.marksList.removeAll()
        
        
        self.cell2.downloadingMarks = true
        self.cell2.marksList.removeAll()
        self.cell2.refresh()
        self.cell3.downloadingDates = true
        self.downloadingAbsences = true
        self.cell3.absenceDates.removeAll()
        self.cell3.refresh()
        self.tableView.reloadData()
        
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        Request.getInstance().requestService(object: self, model: "Scores", task: "GetCurrent", getParameters: ["access_token": Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Attendance", task: "GetAttendance", getParameters: ["access_token": Token], postParameters: [String: String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "List", getParameters: ["access_token": User.getInstance().Token, "message_role": "2", "page_size": "3", "page_index": "0", "unread": "false", "new": "false"], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Membership", task: "Payments", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
    }
    
    override func enableView()
    {
        Request.getInstance().requestService(object: self, model: "Messaging", task: "List", getParameters: ["access_token": User.getInstance().Token, "message_role": "2", "page_size": "3", "page_index": "0", "unread": "false", "new": "false"], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }
    
    override func response(task: String, dictionary: NSDictionary) {
        
        if task == "Scores/GetCurrent"
        {
            
            let ReturnData = dictionary["ReturnData"] as! NSArray
            
            MarkList.buildInstance(data: ReturnData)
            
            DispatchQueue.main.async {
                
                var i = 0
                
                while i < 3 && i < MarkList.getInstance().getMarks().count
                {
                    self.marksList.append(MarkList.getInstance().getMarks()[i])
                    i += 1
                }
                
                self.cell2.marksList = self.marksList
                self.cell2.downloadingMarks = false
                self.cell2.refresh()
                self.tableView.reloadData()
                
            }
            
        }
        else if task == "Messaging/List"
        {
            let ReturnDic = dictionary["ReturnData"] as! NSDictionary
            
            let messagesData = ReturnDic["Messages"] as! NSArray
            
            MessageList.buildInstance(data: messagesData)
            
            DispatchQueue.main.async {
                
                self.messagesList = MessageList.getInstance().getMessages()
                self.cell1.messagesList = MessageList.getInstance().getMessages()
                self.cell1.downloadingMails = false
                self.cell1.refresh()
                self.tableView.reloadData()
                
            }
        }
        else if task == "Attendance/GetAttendance"
        {
            let ReturnDic = dictionary["ReturnData"] as! NSDictionary
            
            Absence.buildInstance(data: ReturnDic)
            
            DispatchQueue.main.async {
                
                self.absentDatesList = Absence.getInstance().getDates()
                self.cell3.absenceDates = Absence.getInstance().getDates()
                self.cell3.downloadingDates = false
                self.downloadingAbsences = false
                self.cell3.refresh()
                self.tableView.reloadData()
                
            }

        }
        else if task == "Membership/Payments"
        {
            let ReturnData = dictionary["ReturnData"] as! NSArray
            
            FamilyPayments.buildInstance(data: ReturnData)
        }
        else if task == "Messaging/UnreadCount"
        {
            let count = dictionary["ReturnData"] as! Int
            
            UserDefaults.standard.set(count, forKey: "UnreadMailsCount")
        }
        
    }
    
    override func responseFault(task: String, error: String)
    {
        if task == "Scores/GetCurrent"
        {
            DispatchQueue.main.async {
                
                var i = 0
                
                while i < 3 && i < MarkList.getInstance().getMarks().count
                {
                    self.marksList.append(MarkList.getInstance().getMarks()[i])
                    i += 1
                }
                
                self.cell2.marksList = self.marksList
                self.cell2.downloadingMarks = false
                self.cell2.refresh()
                self.tableView.reloadData()
                
                if self.errorMessage != nil
                {
                    self.errorMessage.removeFromSuperview()
                    self.errorMessage = nil
                }
                
                self.errorMessage = ErrorMessageView()
                
                self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: error)
                
                self.navigationController?.view.addSubview(self.errorMessage)
                
                //Swift 3 selector syntax
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            }
        }
        
        if task == "Messaging/List"
        {
            
            DispatchQueue.main.async {
                
                self.messagesList = MessageList.getInstance().getMessages()
                self.cell1.messagesList = MessageList.getInstance().getMessages()
                self.cell1.downloadingMails = false
                self.cell1.refresh()
                self.tableView.reloadData()
                
                if self.errorMessage != nil
                {
                    self.errorMessage.removeFromSuperview()
                    self.errorMessage = nil
                }
                
                self.errorMessage = ErrorMessageView()
                
                self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: error)
                
                self.navigationController?.view.addSubview(self.errorMessage)
                
                //Swift 3 selector syntax
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            }
        }
        
        if task == "Attendance/GetAttendance"
        {
            DispatchQueue.main.async {
                
                self.absentDatesList = Absence.getInstance().getDates()
                self.cell3.absenceDates = Absence.getInstance().getDates()
                self.cell3.downloadingDates = false
                self.downloadingAbsences = false
                self.cell3.refresh()
                self.tableView.reloadData()
                
                if self.errorMessage != nil
                {
                    self.errorMessage.removeFromSuperview()
                    self.errorMessage = nil
                }
                
                self.errorMessage = ErrorMessageView()
                
                self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: error)
                
                self.navigationController?.view.addSubview(self.errorMessage)
                
                //Swift 3 selector syntax
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            }
            
        }
        
        if task == "Membership/Payments"
        {
            DispatchQueue.main.async {
                
                if self.errorMessage != nil
                {
                    self.errorMessage.removeFromSuperview()
                    self.errorMessage = nil
                }
                
                self.errorMessage = ErrorMessageView()
                
                self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: error)
                
                self.navigationController?.view.addSubview(self.errorMessage)
                
                //Swift 3 selector syntax
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            }
        }
    }
    
    @objc func removeErrorMessage() {
        if self.errorMessage != nil
        {
            self.errorMessage.removeFromSuperview()
            self.errorMessage = nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cells.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cells[(indexPath as NSIndexPath).row] == 1
        {
            if messagesList.count > 0
            {
                return CGFloat(8) + CGFloat(34) + CGFloat(16) + CGFloat(133) * CGFloat(messagesList.count)
            }
            else
            {
                return CGFloat(8) + CGFloat(34) + CGFloat(16) + CGFloat(41)
            }
        }
        else if cells[(indexPath as NSIndexPath).row] == 2
        {
            if self.marksList.count > 0
            {
                var height = CGFloat(0)
                for mark in self.marksList {
                    if mark.Exams.count / 3 > 0
                    {
                        if mark.Exams.count % 3 != 0
                        {
                            height += CGFloat(166) + CGFloat(mark.Exams.count / 3) * 105.5
                            
                        }
                        else
                        {
                            height += CGFloat(166) + CGFloat((mark.Exams.count / 3) - 1) * 105.5
                        }
                    }
                    else
                    {
                        if mark.Exams.count > 0
                        {
                            height += CGFloat(166)
                        }
                        else
                        {
                            height += CGFloat(43)
                        }
                    }
                }
                
                return CGFloat(34) + CGFloat(16) + height
                
            }
            else
            {
                return CGFloat(34) + CGFloat(16) + CGFloat(41)
            }
        }
        else
        {
            if absentDatesList.count > 0
            {
                return CGFloat(34) + CGFloat(16) + CGFloat(41) + CGFloat(16) + CGFloat(46) * CGFloat(absentDatesList.count)
            }
            else
            {
                if !downloadingAbsences
                {
                    return CGFloat(34) + CGFloat(16) + CGFloat(41) + CGFloat(16)
                }
                else
                {
                    return CGFloat(34) + CGFloat(16) + CGFloat(41) + CGFloat(41) + CGFloat(16)
                }
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cells[(indexPath as NSIndexPath).row] == 1
        {
            cell1 = tableView.dequeueReusableCell(withIdentifier: "Home Cell1", for: indexPath) as? HomeTableViewCell1
            
            return cell1
        }
        else if cells[(indexPath as NSIndexPath).row] == 2
        {
            cell2 = tableView.dequeueReusableCell(withIdentifier: "Home Cell2", for: indexPath) as? HomeTableViewCell2
            
            return cell2
        }
        else
        {
            cell3 = tableView.dequeueReusableCell(withIdentifier: "Home Cell3", for: indexPath) as? HomeTableViewCell3
            
            return cell3
        }
        
    }

    @objc func showEmailAction(_ sender : NSNotification) {
        self.performSegue(withIdentifier: "Show Email", sender: sender.object)
    }

    override func deleteMail(messageID: String)
    {
        var removedIndex = 0
        for item in messagesList {
            
            if item.MessageID == messageID
            {
                messagesList.remove(at: removedIndex)
                self.cell1.messagesList = messagesList
                self.cell1.downloadingMails = false
                self.cell1.refresh()
                self.tableView.reloadData()
                Request.getInstance().requestService(object: self, model: "Messaging", task: "List", getParameters: ["access_token": User.getInstance().Token, "message_role": "2", "page_size": "3", "page_index": "0", "unread": "false", "new": "false"], postParameters: [String : String]())
                break
            }
            removedIndex = removedIndex + 1
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Email"
        {
            let dest = segue.destination as! MailDetails
            
            dest.messageID = messagesList[(sender as! IndexPath).row].MessageID
            
            self.cell1.messagesList = messagesList
            self.cell1.refresh()
            self.tableView.reloadData()
            
        }
    }
    @IBAction func chose_child(_ sender: UIButton) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Children List PopOver") as! ChildrenList
        popOverVC.parentObject = self
        self.navigationController?.addChild(popOverVC)
        popOverVC.view.frame = (self.navigationController?.view.frame)!
        self.navigationController?.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let verticalIndicator: UIView = (scrollView.subviews[(scrollView.subviews.count - 1)] )
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }
}
