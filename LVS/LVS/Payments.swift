//
//  Payments.swift
//  LVS
//
//  Created by Jalal on 1/7/17.
//  Copyright © 2017 Abd Al Majed. All rights reserved.
//

import UIKit

class Payments: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var showMenu: UIButton!
    @IBOutlet weak var chosenChild: UIButton!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var total: UIView!
    @IBOutlet weak var totalPayments: UIView!
    @IBOutlet weak var netTotal: UIView!
    
    @IBOutlet weak var total_width: NSLayoutConstraint!
    
    @IBOutlet weak var totalPayments_width: NSLayoutConstraint!
    
    @IBOutlet weak var netTotal_width: NSLayoutConstraint!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var totalPaymentLabel: UILabel!
    
    @IBOutlet weak var netTotalLabel: UILabel!
    
    @IBOutlet weak var netTotalValueLabel: UILabel!
    
    @IBOutlet weak var totalPaymentValueLabel: UILabel!
    
    @IBOutlet weak var totalValueLabel: UILabel!
    
    var studentPayment: StudentPayments!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.delegate = self
        self.tableview.dataSource = self

        self.navigationItem.title = NSLocalizedString("payments", comment: "")
        
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
        
        self.chosenChild.isEnabled = true
        self.showMenu.isEnabled = true
        
        let Name = UserDefaults.standard.value(forKey: "ActiveName") as! String
        self.chosenChild.setTitle(Name, for: .normal)
        
        self.view.backgroundColor = Colors.getInstance().colorBackground
        
        self.tableview.backgroundColor = Colors.getInstance().colorBackground
        
        self.total.backgroundColor = Colors.getInstance().colorPositive
        
        self.totalPayments.backgroundColor = Colors.getInstance().colorContract
        
        self.netTotal.backgroundColor = Colors.getInstance().colorNegative
        
        self.total_width.constant = self.view.frame.width / 3
        
        self.totalPayments_width.constant = self.view.frame.width / 3
        
        self.netTotal_width.constant = self.view.frame.width / 3
        
        self.totalLabel.adjustsFontSizeToFitWidth = true
        
        self.totalPaymentLabel.adjustsFontSizeToFitWidth = true
        
        self.netTotalLabel.adjustsFontSizeToFitWidth = true
        
        self.totalValueLabel.adjustsFontSizeToFitWidth = true
        
        self.totalPaymentValueLabel.adjustsFontSizeToFitWidth = true
        
        self.netTotalValueLabel.adjustsFontSizeToFitWidth = true
        
        self.totalLabel.text = NSLocalizedString("total", comment: "") 
        
        self.totalPaymentLabel.text = NSLocalizedString("total_payment", comment: "") 
        
        self.netTotalLabel.text = NSLocalizedString("net_total", comment: "")
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        self.studentPayment = FamilyPayments.getInstance().getStudentPayments(token: Token)
        
        self.totalValueLabel.text = "\(studentPayment.NetTotal)"
        
        self.totalPaymentValueLabel.text = "\(studentPayment.PaymentsSum)"
        
        self.netTotalValueLabel.text = "\(studentPayment.Balance)"
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
        
    }
    
    override func enableViewWithRefresh()
    {
        let Name = UserDefaults.standard.value(forKey: "ActiveName") as! String
        self.chosenChild.setTitle(Name, for: .normal)
        
        let Token = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        self.studentPayment = FamilyPayments.getInstance().getStudentPayments(token: Token)
        
        self.totalValueLabel.text = "\(studentPayment.Balance)"
        
        self.totalPaymentValueLabel.text = "\(studentPayment.PaymentsSum)"
        
        self.netTotalValueLabel.text = "\(studentPayment.NetTotal)"

        
        self.tableview.reloadData()
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
    }
    
    override func enableView()
    {
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }

    override func response(task: String, dictionary: NSDictionary) {
        if task == "Messaging/UnreadCount"
        {
            let count = dictionary["ReturnData"] as! Int
            
            UserDefaults.standard.set(count, forKey: "UnreadMailsCount")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.studentPayment.Payments.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Payment Cell", for: indexPath) as! PaymentTableViewCell
        if indexPath.row == 0
        {
            cell.paymentData = PaymentData(No: NSLocalizedString("number", comment: ""), Value: NSLocalizedString("value", comment: ""), Date: NSLocalizedString("date", comment: ""))
        }
        else
        {
            let payment = self.studentPayment.Payments[indexPath.row - 1]
            
            cell.paymentData = PaymentData(No: "\(payment.PaymentNumber)", Value: "\(payment.PaymentAmount)", Date: "\(payment.PaymentDate)")
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
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIView = (scrollView.subviews[(scrollView.subviews.count - 1)] )
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }


}
