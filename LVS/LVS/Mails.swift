//
//  MailsTableViewController.swift
//  LVS
//
//  Created by Jalal on 12/15/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class MailsTableViewController: UITableViewController {
    @IBOutlet weak var showMenu: UIButton!
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var refresh: UIRefreshControl = UIRefreshControl()

    var pageIndex: Int = 0
    let pageSize = 25
    let indexOfFetching = 5
    var messagesList: [MessageHeader] = [MessageHeader]()
    var total = 0
    var start_X = -50
    
    var errorMessage: ErrorMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = NSLocalizedString("mail", comment: "")
        
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
        
        self.indicator.isHidden = false
        self.indicator.color = Colors.getInstance().colorAccent
        self.indicator.center = (self.navigationController?.view.center)!
        self.indicator.startAnimating()
        self.navigationController?.view.addSubview(self.indicator)
        
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresh) // not required when using UITableViewController
    
        refresh.tintColor = Colors.getInstance().colorAccent
        
        self.view.backgroundColor = Colors.getInstance().colorBackground
        
        pageIndex = 0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "SetViewMessages", getParameters: ["access_token": User.getInstance().Token, "page_size": "\(pageSize)", "page_index": "\(pageIndex)"], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "List", getParameters: ["access_token": User.getInstance().Token, "message_role": "2", "page_size": "\(pageSize)", "page_index": "\(pageIndex)", "unread": "false", "new": "false"], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }
    
    @objc func refresh(sender:AnyObject) {
        
        self.indicator.stopAnimating()
        
        self.indicator.isHidden = true
        
        self.messagesList.removeAll()
        
        self.tableView.reloadData()
        
        pageIndex = 0
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "SetViewMessages", getParameters: ["access_token": User.getInstance().Token, "page_size": "\(pageSize)", "page_index": "\(pageIndex)"], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "List", getParameters: ["access_token": User.getInstance().Token, "message_role": "2", "page_size": "\(pageSize)", "page_index": "\(pageIndex)", "unread": "false", "new": "false"], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func deleteMail(messageID: String)
    {
        var removedIndex = 0
        for item in messagesList {
            
            if item.MessageID == messageID
            {
                messagesList.remove(at: removedIndex)
                break
            }
            removedIndex = removedIndex + 1
        }
        self.start_X = -50
        self.tableView.reloadData()
    }
    
    override func response(task: String, dictionary: NSDictionary) {
        
        if task == "Messaging/List"
        {
            let ReturnDic = dictionary["ReturnData"] as! NSDictionary
            
            total = ReturnDic["Total"] as! Int
            
            let messagesData = ReturnDic["Messages"] as! NSArray
            
            MessageList.buildInstance(data: messagesData)
            
            DispatchQueue.main.async {
                
                self.messagesList.append(contentsOf: MessageList.getInstance().getMessages())
                
                self.indicator.stopAnimating()
                
                self.indicator.isHidden = true
                
                self.start_X = -50
                
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
        if task == "Messaging/List"
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.messagesList.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mail Cell", for: indexPath) as! MailTableViewCell
        if self.messagesList.count > 0
        {
            let message = self.messagesList[(indexPath as NSIndexPath).row]
            
            cell.message = message
            
            if (self.messagesList.count < self.total) && indexPath.row == (self.messagesList.count - indexOfFetching)
            {
                pageIndex = pageIndex + 1
                
                Request.getInstance().requestService(object: self, model: "Messaging", task: "List", getParameters: ["access_token": User.getInstance().Token, "message_role": "2", "page_size": "\(pageSize)", "page_index": "\(pageIndex)", "unread": "false", "new": "false"], postParameters: [String : String]())
            }
            
        }
        return cell
    }
    
    /*override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // 1. set the initial state of the cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, CGFloat(self.start_X), 0, 25)
        cell.layer.transform = transform
        
        self.start_X += -5
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        })
    }*/
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.messagesList[indexPath.row].IsRead = true
        self.performSegue(withIdentifier: "Show Email", sender: indexPath)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Email"
        {
            let dest = segue.destination as! MailDetails
            
            dest.messageID = messagesList[(sender as! IndexPath).row].MessageID
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIView = (scrollView.subviews[(scrollView.subviews.count - 1)] )
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }
    

}
