//
//  TeachingStaff.swift
//  LVS
//
//  Created by Jalal on 12/12/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class TeachingStaff: UITableViewController {

    @IBOutlet weak var showMenu: UIButton!
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var teachersList = [Teacher]()
    
    var errorMessage: ErrorMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension

        self.navigationItem.title = NSLocalizedString("teaching_staff", comment: "")
        
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
        
        self.indicator.isHidden = false
        self.indicator.color = Colors.getInstance().colorAccent
        self.indicator.center = (self.navigationController?.view.center)!
        self.indicator.startAnimating()
        self.navigationController?.view.addSubview(self.indicator)
        
        self.view.backgroundColor = Colors.getInstance().colorBackground
        
        let lang = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String
        
        var langID: Int
        
        if lang == "ar"
        {
            langID = 2
        }
        else
        {
            langID = 1
        }
        
        Request.getInstance().requestService(object: self, model: "Misc", task: "TeachersList", getParameters: ["lang": "\(langID)"], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func response(task: String, dictionary: NSDictionary) {
        
        if task == "Misc/TeachersList"
        {
            let notesData = dictionary["ReturnData"] as! NSArray
            
            TeacherList.buildInstance(data: notesData)
            
            DispatchQueue.main.async {
                
                self.indicator.stopAnimating()
                
                self.indicator.isHidden = true
                
                self.teachersList = TeacherList.getInstance().getTeachers()
                
                self.tableView.reloadData()
                
            }
        }
        else if task == "Messaging/UnreadCount"
        {
            let count = dictionary["ReturnData"] as! Int
            
            UserDefaults.standard.set(count, forKey: "UnreadMailsCount")
        }
        
    }
    
    override func responseFault(task: String, error: String)
    {
        if task == "Misc/TeachersList"
        {
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                
                self.indicator.isHidden = true
                
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
        return self.teachersList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Staff Cell", for: indexPath) as! StaffTableViewCell
        
        
        let teacher = self.teachersList[(indexPath as NSIndexPath).row]
        
        var cellStaff = Staff(Name: teacher.TeacherName, Contenet: teacher.getMaterialsString(), isLast: false)
        
        if (indexPath.row) == (self.teachersList.count - 1)
        {
            cellStaff.isLast = true
        }
        
        cell.staff = cellStaff
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIView = (scrollView.subviews[(scrollView.subviews.count - 1)] )
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }

}
