//
//  MailDetails.swift
//  LVS
//
//  Created by Jalal on 12/17/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit
import WebKit

class MailDetails: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var sender: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var body: WKWebView!
    @IBOutlet weak var attachments: UICollectionView!
    
    var messageID: String!
    var Message_Title: String!
    var MessageDate: String!
    var SenderTitle: String!
    var MessageBody: String!
    var attachmentsList: [Attachment] = [Attachment]()
    
    var deletingAlert: UIAlertController!
    
    var errorMessage: ErrorMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delete.setTitle(NSLocalizedString("delete", comment: ""), for: .normal)
        sender.isHidden = true
        messageTitle.isHidden = true
        date.isHidden = true
        body.isHidden = true
        attachments.isHidden = true
        
        attachments.delegate = self
        attachments.dataSource = self
        
        if (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String == "ar"
        {
            date.textAlignment = .left
        }
        
        date.textColor = Colors.getInstance().colorPrimary
        
        self.view.backgroundColor = Colors.getInstance().colorBackground
        attachments.backgroundColor = Colors.getInstance().colorBackground
        self.body.backgroundColor = Colors.getInstance().colorBackground
        
        sender.adjustsFontSizeToFitWidth = true
        date.adjustsFontSizeToFitWidth = true
        messageTitle.adjustsFontSizeToFitWidth = true
        
        
        self.body.scrollView.bounces = false
        self.body.scrollView.isDirectionalLockEnabled = false
        self.body.scrollView.isScrollEnabled = false
        
        // Do any additional setup after loading the view.
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "GetMessage", getParameters: ["access_token": User.getInstance().Token, "message_id": messageID], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func response(task: String, dictionary: NSDictionary) {
        
        if task == "Messaging/GetMessage"
        {
            let ReturnDic = dictionary["ReturnData"] as! NSDictionary
            
            Message_Title = ReturnDic["Title"] as? String
            
            MessageDate = ReturnDic["MessageDate"] as? String
            
            SenderTitle = ReturnDic["SenderTitle"] as? String
            
            MessageBody = ReturnDic["Body"] as? String
            
            let attachmentsData = ReturnDic["Attachments"] as! NSArray
            
            AttachmentList.buildInstance(data: attachmentsData)
            
            DispatchQueue.main.async {
                self.sender.isHidden = false
                self.messageTitle.isHidden = false
                self.date.isHidden = false
                self.body.isHidden = false
                self.attachments.isHidden = false
                
                self.messageTitle.text = self.Message_Title
                self.date.text = self.MessageDate
                self.sender.text = self.SenderTitle
                
                if (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String == "ar"
                {
                    self.body.loadHTMLString("<div style='text-align:right'>\(self.MessageBody!)<div>", baseURL: nil)
                }
                else
                {
                    self.body.loadHTMLString("<div style='text-align:left'>\(self.MessageBody!)<div>", baseURL: nil)
                }
                
                self.attachmentsList = AttachmentList.getInstance().getAttachments()
                self.attachments.reloadData()
                
            }
        }
        else if task == "Messaging/UnreadCount"
        {
            let count = dictionary["ReturnData"] as! Int
            
            UserDefaults.standard.set(count, forKey: "UnreadMailsCount")
        }
        else if task == "Messaging/Delete"
        {
            let ReturnData = dictionary["ReturnData"] as! Bool
            if ReturnData
            {
                DispatchQueue.main.async {
                    
                    self.deletingAlert.title = NSLocalizedString("mail_has_been_deleted", comment: "")
                    self.deletingAlert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
                        _ = self.navigationController?.popViewController(animated: true)
                        self.navigationController?.topViewController?.deleteMail(messageID: self.messageID)
                    }))
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.deletingAlert.title = NSLocalizedString("failed_to_delete_mail", comment: "")
                    self.deletingAlert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
                        
                    }))
                }
            }
        }
    }
    
    override func responseFault(task: String, error: String)
    {
        if task == "Messaging/GetMessage"
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.attachmentsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Attachment Cell", for: indexPath) as! AttachmentCell
        
        // Configure the cell
        cell.attachment = self.attachmentsList[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.attachments.frame.width - 5 , height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "downloadingPopOver") as! DownloadingPopOverViewController
        popOverVC.attachment = self.attachmentsList[indexPath.row]
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    @IBAction func deleteMail(_ sender: UIButton) {
        let DeleteAlert = UIAlertController(title: NSLocalizedString("deleteAlert_title", comment: ""), message: NSLocalizedString("deleteAlert_message", comment: ""), preferredStyle: UIAlertController.Style.alert)
        
        DeleteAlert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action: UIAlertAction!) in
            Request.getInstance().requestService(object: self, model: "Messaging", task: "Delete", getParameters: ["access_token": User.getInstance().Token, "message_id": self.messageID, "message_role": "2"], postParameters: [String : String]())
            DispatchQueue.main.async {
                self.deletingAlert = UIAlertController(title: NSLocalizedString("deleteing_mail", comment: ""), message: nil, preferredStyle: UIAlertController.Style.alert)

                self.present(self.deletingAlert, animated: true, completion: nil)
            }
        }))
        
        DeleteAlert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(DeleteAlert, animated: true, completion: nil)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }

}
