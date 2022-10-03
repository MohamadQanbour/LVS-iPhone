//
//  Profile.swift
//  LVS
//
//  Created by Jalal on 12/13/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class Profile: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var showMenu: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var full_name: UILabel!
    @IBOutlet weak var change_password: UIButton!
    @IBOutlet weak var old_password: UITextField!
    @IBOutlet weak var new_password: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    var errorMessage: ErrorMessageView!
    
    var loading: LoadingView!
    
    var ActiveTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = NSLocalizedString("profile", comment: "")
        
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
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.removeKeyboard(_:)))
        
        self.view.addGestureRecognizer(Tap)
        
        self.view.backgroundColor = Colors.getInstance().colorBackground
        
        name.text = NSLocalizedString("name", comment: "")
        change_password.setTitle(NSLocalizedString("change_password", comment: ""), for: .normal)
        old_password.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("old_password", comment: ""),attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): Colors.getInstance().colorAccent]))
        new_password.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("new_password", comment: ""),attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): Colors.getInstance().colorAccent]))
        submit.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
        
        full_name.text = User.getInstance().fullName
        
        change_password.backgroundColor = Colors.getInstance().colorAccent
        old_password.backgroundColor = Colors.getInstance().colorPrimary.withAlphaComponent(0.2)
        new_password.backgroundColor = Colors.getInstance().colorPrimary.withAlphaComponent(0.2)
        submit.backgroundColor = Colors.getInstance().colorAccent
        
        old_password.isHidden = true
        new_password.isHidden = true
        submit.isHidden = true
        
        self.old_password.isEnabled = false
        self.new_password.isEnabled = false
        self.submit.isEnabled = false
        
        self.old_password.delegate = self
        self.new_password.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        
        // 1. set the initial state of the cell
        
        old_password.isHidden = false
        new_password.isHidden = false
        submit.isHidden = false
        
        self.old_password.isEnabled = true
        self.new_password.isEnabled = true
        self.submit.isEnabled = true
        
        change_password.alpha = 1.0
        let change_passwordTransform = CATransform3DIdentity
        change_password.layer.transform = change_passwordTransform
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            self.change_password.alpha = 0
            self.change_password.layer.transform = CATransform3DIdentity
            }) { (true) in
                self.change_password.isHidden = true
        }
        
        
        old_password.alpha = 0
        let old_passwordTransform = CATransform3DTranslate(CATransform3DIdentity, -old_password.frame.width, 0, 0)
        old_password.layer.transform = old_passwordTransform
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            self.old_password.alpha = 1.0
            self.old_password.layer.transform = CATransform3DIdentity
        })
        
        new_password.alpha = 0
        let new_passwordTransform = CATransform3DTranslate(CATransform3DIdentity, self.view.frame.width, 0, 0)
        new_password.layer.transform = new_passwordTransform
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            self.new_password.alpha = 1.0
            self.new_password.layer.transform = CATransform3DIdentity
        })
        
        submit.alpha = 0
        let submitTransform = CATransform3DIdentity
        submit.layer.transform = submitTransform
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            self.submit.alpha = 1.0
            self.submit.layer.transform = CATransform3DIdentity
        })
        
        
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        if self.ActiveTextField != nil
        {
            self.ActiveTextField.resignFirstResponder()
        }
        
        let old_password = self.old_password.text
        let new_password = self.new_password.text
        if Security.getInstance().isStringEmpty(old_password!) {
            
            if self.errorMessage != nil
            {
                self.errorMessage.removeFromSuperview()
                self.errorMessage = nil
            }
            
            self.errorMessage = ErrorMessageView()
            
            self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: NSLocalizedString("old_password_required", comment: ""))
            
            self.navigationController?.view.addSubview(self.errorMessage)
            
            //Swift 3 selector syntax
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            
            return
        }
        
        if Security.getInstance().isStringEmpty(new_password!)
        {
            
            if self.errorMessage != nil
            {
                self.errorMessage.removeFromSuperview()
                self.errorMessage = nil
            }
            
            self.errorMessage = ErrorMessageView()
            
            self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: NSLocalizedString("new_password_required", comment: ""))
            
            self.navigationController?.view.addSubview(self.errorMessage)
            
            //Swift 3 selector syntax
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            
            return
        }
        
        submit.alpha = 1.0
        let submitTransform = CATransform3DIdentity
        submit.layer.transform = submitTransform
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            self.submit.alpha = 0
            self.submit.layer.transform = CATransform3DIdentity
        })
        
        loading = LoadingView()
        
        loading.draw(midX: submit.center.x, midY: submit.center.y, ballDim: 25, ballsCount: 5, activeColor: Colors.getInstance().colorAccent, nonActiveColor: Colors.getInstance().colorPrimary.withAlphaComponent(0.2))
        
        self.view.addSubview(loading)
        
        self.submit.isEnabled = false
        self.old_password.isEnabled = false
        self.new_password.isEnabled = false
        
        Request.getInstance().requestService(object: self, model: "Membership", task: "ChangePassword", getParameters: ["access_token": User.getInstance().Token, "old_password": old_password!, "new_password": new_password!], postParameters: [String: String]())
        
        Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": User.getInstance().Token], postParameters: [String: String]())
        
    }
    
        override func response(task: String, dictionary: NSDictionary) {
        
        if task == "Membership/ChangePassword"
        {
            DispatchQueue.main.async {
            let ReturnData = dictionary["ReturnData"] as! Bool
            
                self.submit.isEnabled = true
            
            self.old_password.isEnabled = true
            
            self.new_password.isEnabled = true
            
            self.loading.removeFromSuperview()
            
            self.loading = nil
            
            if ReturnData
            {
                if self.errorMessage != nil
                {
                    self.errorMessage.removeFromSuperview()
                    self.errorMessage = nil
                }
                
                self.errorMessage = ErrorMessageView()
                
                self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: NSLocalizedString("password_has_changed", comment: ""))
                
                self.navigationController?.view.addSubview(self.errorMessage)
                
                //Swift 3 selector syntax
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
                
                self.change_password.isHidden = false
                self.submit.isHidden = true
                
                self.submit.isEnabled = false
                
                self.old_password.isEnabled = false
                
                self.new_password.isEnabled = false
                
                self.old_password.text = ""
                self.new_password.text = ""
                
                self.change_password.alpha = 0
                let change_passwordTransform = CATransform3DIdentity
                self.change_password.layer.transform = change_passwordTransform
                
                // 2. UIView animation method to change to the final state of the cell
                UIView.animate(withDuration: 1.0, animations: {
                    self.change_password.alpha = 1.0
                    self.change_password.layer.transform = CATransform3DIdentity
                })
                
                
                self.old_password.alpha = 1.0
                let old_passwordTransform = CATransform3DIdentity
                self.old_password.layer.transform = old_passwordTransform
                
                // 2. UIView animation method to change to the final state of the cell
                UIView.animate(withDuration: 1.0, animations: { 
                    self.old_password.alpha = 0
                    self.old_password.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -self.old_password.frame.width, 0, 0)
                    }, completion: { (true) in
                        self.old_password.isHidden = true
                })
                
                self.new_password.alpha = 1.0
                let new_passwordTransform = CATransform3DIdentity
                self.new_password.layer.transform = new_passwordTransform
                
                // 2. UIView animation method to change to the final state of the cell
                UIView.animate(withDuration: 1.0, animations: { 
                    self.new_password.alpha = 0
                    self.new_password.layer.transform = CATransform3DTranslate(CATransform3DIdentity, self.view.frame.width, 0, 0)
                    }, completion: { (true) in
                        self.new_password.isHidden = true
                })
                
            }
            else
            {
                if self.errorMessage != nil
                {
                    self.errorMessage.removeFromSuperview()
                    self.errorMessage = nil
                }
       		         
                self.errorMessage = ErrorMessageView()
                
                self.errorMessage.draw(x: 20, y: self.view.frame.height - 50, width: self.view.frame.width - 40, message: NSLocalizedString("password_has_not_changed", comment: ""))
                
                self.navigationController?.view.addSubview(self.errorMessage)
                
                //Swift 3 selector syntax
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
                
                self.submit.alpha = 0
                let submitTransform = CATransform3DIdentity
                self.submit.layer.transform = submitTransform
                
                // 2. UIView animation method to change to the final state of the cell
                UIView.animate(withDuration: 1.0, animations: {
                    self.submit.alpha = 1.0
                    self.submit.layer.transform = CATransform3DIdentity
                })

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
        if task == "Membership/ChangePassword"
        {
            DispatchQueue.main.async {
                
                self.submit.isEnabled = true
                
                self.old_password.isEnabled = true
                
                self.new_password.isEnabled = true
                
                self.loading.removeFromSuperview()
                
                self.loading = nil
                
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
                
                self.submit.alpha = 0
                let submitTransform = CATransform3DIdentity
                self.submit.layer.transform = submitTransform
                
                // 2. UIView animation method to change to the final state of the cell
                UIView.animate(withDuration: 1.0, animations: {
                    self.submit.alpha = 1.0
                    self.submit.layer.transform = CATransform3DIdentity
                })
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.ActiveTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.ActiveTextField = nil
    }
    
    @objc func removeKeyboard(_ sender: UITapGestureRecognizer)
    {
        if self.ActiveTextField != nil
        {
            self.ActiveTextField.resignFirstResponder()
            self.ActiveTextField = nil

        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
