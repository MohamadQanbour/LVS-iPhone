//
//  Notes.swift
//  LVS
//
//  Created by Jalal on 12/12/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class Notes: UITableViewController {

    @IBOutlet weak var showMenu: UIButton!
    @IBOutlet weak var chosenChild: UIButton!
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var refresh: UIRefreshControl = UIRefreshControl()
    
    var notesList: [Note] = [Note]()
    
    var start_X = -50
    
    var errorMessage: ErrorMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = NSLocalizedString("notes", comment: "")
                
        self.tableView.estimatedRowHeight = 117
        self.tableView.rowHeight = UITableView.automaticDimension
        
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
        
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresh) // not required when using UITableViewController
        
        refresh.tintColor = Colors.getInstance().colorAccent
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        
        Request.getInstance().requestService(object: self, model: "Misc", task: "GetNotes", getParameters: ["access_token": Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        

    }
    
    override func enableViewWithRefresh()
    {
        self.notesList.removeAll()
        
        self.tableView.reloadData()
        
        self.indicator.startAnimating()
        
        self.indicator.isHidden = false
        
        let Name = UserDefaults.standard.value(forKey: "ActiveName") as! String
        self.chosenChild.setTitle(Name, for: .normal)
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        Request.getInstance().requestService(object: self, model: "Misc", task: "GetNotes", getParameters: ["access_token": Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
    }
    
    override func enableView()
    {
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refresh(sender:AnyObject) {
        
        self.indicator.stopAnimating()
        
        self.indicator.isHidden = true
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        Request.getInstance().requestService(object: self, model: "Misc", task: "GetNotes", getParameters: ["access_token": Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }

    override func response(task: String, dictionary: NSDictionary) {
        
        if task == "Misc/GetNotes"
        {
            let notesData = dictionary["ReturnData"] as! NSArray
            
            NoteList.buildInstance(data: notesData)
            
            DispatchQueue.main.async {
                
                self.notesList = NoteList.getInstance().getNotes()
                
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
        if task == "Misc/GetNotes"
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
       return self.notesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note Cell", for: indexPath) as! NoteTableViewCell
        if self.notesList.count > 0
        {
            let note = self.notesList[(indexPath as NSIndexPath).row]
            
            cell.note = note
            
        }
        return cell
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
