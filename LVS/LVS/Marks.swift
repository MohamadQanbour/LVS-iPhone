//
//  Mark.swift
//  LVS
//
//  Created by Jalal on 12/12/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class Mark: UITableViewController {

    @IBOutlet weak var showMenu: UIButton!
    
    @IBOutlet weak var chosenChild: UIButton!
    var marksList: [MaterialMark] = [MaterialMark]()
    
    var start_X = -50
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var refresh: UIRefreshControl = UIRefreshControl()
    
    var errorMessage: ErrorMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = NSLocalizedString("mark", comment: "")
                
        //self.tableView.estimatedRowHeight = 166
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        
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
        
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresh) // not required when using UITableViewController
        
        refresh.tintColor = Colors.getInstance().colorAccent
        
        self.indicator.isHidden = true
        self.indicator.color = Colors.getInstance().colorAccent
        self.indicator.center = (self.navigationController?.view.center)!
        self.navigationController?.view.addSubview(self.indicator)
        
        self.view.backgroundColor = Colors.getInstance().colorBackground
        
        self.indicator.frame = CGRect(x: self.view.frame.width / 2 - 25 , y: self.view.frame.height / 2 - 25, width: 50, height: 50)
        self.indicator.startAnimating()
        
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
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        Request.getInstance().requestService(object: self, model: "Scores", task: "GetCurrent", getParameters: ["access_token": Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }
    
    override func enableViewWithRefresh() 
    {
        self.marksList.removeAll()
        
        self.tableView.reloadData()
        
        self.indicator.startAnimating()
        
        self.indicator.isHidden = false
        
        let Name = UserDefaults.standard.value(forKey: "ActiveName") as! String
        self.chosenChild.setTitle(Name, for: .normal)
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        Request.getInstance().requestService(object: self, model: "Scores", task: "GetCurrent", getParameters: ["access_token": Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
    }
    
    override func enableView()
    {
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }
    
    @objc func refresh(sender:AnyObject) {
        
        self.indicator.stopAnimating()
        
        self.indicator.isHidden = true
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        Request.getInstance().requestService(object: self, model: "Scores", task: "GetCurrent", getParameters: ["access_token": Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }
    
    override func response(task: String, dictionary: NSDictionary) {
        if task == "Scores/GetCurrent"
        {
            
            let ReturnData = dictionary["ReturnData"] as! NSArray
            
            MarkList.buildInstance(data: ReturnData)
            
            DispatchQueue.main.async {
                
                self.indicator.stopAnimating()
                
                self.indicator.isHidden = true
                
                self.marksList = MarkList.getInstance().getMarks()
                
                self.tableView.reloadData()
                
                self.refresh.endRefreshing()
                
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
        if task == "Scores/GetCurrent"
        {
            DispatchQueue.main.async {
                
                self.refresh.endRefreshing()
                
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.marksList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mark Cell", for: indexPath) as! MarkTableViewCell
        if self.marksList.count > 0
        {
            let mark = self.marksList[(indexPath as NSIndexPath).row]
            
            cell.mark = mark
            
            cell.refresh()
        }
        return cell
    }
    
    /*override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // 1. set the initial state of the cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, CGFloat(self.start_X), -250, -250)
        cell.layer.transform = transform
        
        self.start_X += -10
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        })
    }*/


    @IBAction func chose_child(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Children List PopOver") as! ChildrenList
        popOverVC.parentObject = self
        self.navigationController?.addChild(popOverVC)
        popOverVC.view.frame = (self.navigationController?.view.frame)!
        self.navigationController?.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIView = (scrollView.subviews[(scrollView.subviews.count - 1)] )
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }

}
