//
//  CallUs.swift
//  LVS
//
//  Created by Jalal on 12/13/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

struct Contact {
    var depName: String
    var mobile: String
    var dash: String
    var phone: String
}

class CallUs: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var showMenu: UIButton!
    
    @IBOutlet weak var contactsTableView: UITableView!
    let contacts = [Contact(depName: "أرقام المدرسة:", mobile: "0988008222", dash: "-", phone: "0116010"),
                    Contact(depName: "", mobile: "0988003222", dash: "", phone: ""),
                    Contact(depName: "المديرة الإدارية:", mobile: "0934020430", dash: "", phone: ""),
                    Contact(depName: "المحاسبة:", mobile: "0934020446", dash: "", phone: ""),
                    Contact(depName: "أمانة السر:", mobile: "0934020445", dash: "", phone: ""),
                    Contact(depName: "مسؤول النقل:", mobile: "0934020444", dash: "", phone: ""),
                    Contact(depName: "شؤون الموظفين:", mobile: "093420441", dash: "", phone: ""),
                    Contact(depName: "مسؤول التطبيق:", mobile: "0992112996", dash: "", phone: ""),
                    Contact(depName: "قسم الإنكليزي:", mobile: "0932611622", dash: "", phone: ""),
                    Contact(depName: "الحضانات:", mobile: "0934020436", dash: "", phone: ""),
                    Contact(depName: "صف أول وثاني:", mobile: "0934020438", dash: "", phone: ""),
                    Contact(depName: "صف ثالث رابع خامس سادس:", mobile: "0934020434", dash: "", phone: ""),
                    Contact(depName: "إعدادي وثانوي:", mobile: "0934020432", dash: "", phone: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
        
        self.navigationItem.title = NSLocalizedString("call_us", comment: "")
        
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
        
        NotificationCenter.default.addObserver(self , selector: #selector(Home.showEmailAction(_:)), name: NSNotification.Name(rawValue: "Call"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contacts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Call Us Cell", for: indexPath) as! CallUsTableViewCell
        
        let contact = self.contacts[indexPath.row]
        
        cell.contact = contact
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentLength = CGFloat(contacts.count) * 44.0
        
        
        if(scrollView.contentOffset.y < 0)
        {
            scrollView.contentOffset.y = 0
        }
        
        if scrollView.contentOffset.y > contentLength - self.view.frame.height
        {
            if((CGFloat(contentLength) - self.view.frame.height) >= CGFloat(0))
            {
                scrollView.contentOffset.y = contentLength - self.view.frame.height
            }
            else
            {
                scrollView.contentOffset.y = 0
            }
        }
        
        let verticalIndicator: UIView = (scrollView.subviews[(scrollView.subviews.count - 1)] )
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
    }
    
    func showEmailAction(_ sender : NSNotification) {
        
        let label = sender.object as! UILabel
        
        let alert = UIAlertController(title: label.text , message: "" , preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("call", comment: "") , style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) -> Void in
            UIApplication.shared.open(URL(string : "tel://" + label.text! )! )
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "") , style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
