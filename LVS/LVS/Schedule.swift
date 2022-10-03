//
//  Schedule.swift
//  LVS
//
//  Created by Jalal on 12/13/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit
import WebKit

class Schedule: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var showMenu: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    let googleDocsService = "https://docs.google.com/gview?embedded=true&url="
    
    var errorMessage: ErrorMessageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = NSLocalizedString("schedule", comment: "")
                
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
        
        
        self.webView.scrollView.bounces = false
        self.webView.scrollView.isDirectionalLockEnabled = false
        self.webView.scrollView.isScrollEnabled = false
        self.webView.navigationDelegate = self
        
        Request.getInstance().requestService(object: self, model: "Misc", task: "ScheduleFile", getParameters: ["access_token": User.getInstance().Token], postParameters: [String : String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
//                                     let height = height as! CGFloat
//                                     print(height)
//                                     self.heightViewAddress.constant = height
//                                     self.view.layoutSubviews()
//                                     self.view.layoutIfNeeded()
//                                     //self.loaderView.isHidden = true
//                                 })
    }
    
    override func response(task: String, dictionary: NSDictionary) {
        
        if task == "Misc/ScheduleFile"
        {
            let scheduleFileUrl = dictionary["ReturnData"] as! String
            if scheduleFileUrl != ""
            {
                let targetURL = googleDocsService + scheduleFileUrl
                
                DispatchQueue.main.async {
                    
                    let url = NSURL (string: targetURL);
                    let requestObj = NSURLRequest(url: url! as URL);
                    self.webView.load(requestObj as URLRequest);
                    
                    self.indicator.stopAnimating()
                    
                    self.indicator.isHidden = true
                    
                }
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
        if task == "Misc/ScheduleFile"
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }

}
