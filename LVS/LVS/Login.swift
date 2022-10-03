//
//  Login.swift
//  LVS
//
//  Created by Jalal on 12/11/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class Login: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var user_id: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    
    var passwordExtension = "LVS2016"
    var token:String = String()
    var userType:Int = Int()
    var fullName:String = String()
    var email:String = String()
    
    var ActiveTextField: UITextField!
    
    var errorMessage: ErrorMessageView!
    
    var loading : LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.removeKeyboard(_:)))
        
        self.backgroundImage.addGestureRecognizer(Tap)
        
        self.logo.addGestureRecognizer(Tap)
        
        self.view.addGestureRecognizer(Tap)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        user_id.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("user_id", comment: ""),                                                               attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): Colors.getInstance().colorAccent]))
        
        password.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("password", comment: ""),                                                               attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): Colors.getInstance().colorAccent]))
        
        login.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        
        user_id.delegate = self
        password.delegate = self
        
        user_id.textColor = UIColor.white
        password.textColor = UIColor.white

        logoWidth.constant = self.view.frame.width / 2
        
        logoHeight.constant = logoWidth.constant / 2
        
        if UserDefaults.standard.value(forKey: "Token") != nil
        {
            icon.isHidden = true
            user_id.isHidden = true
            password.isHidden = true
            login.isHidden = true
            
        }
        else
        {
            icon.alpha = 0
            let iconTransform = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, 0, 0, 0), self.view.center.x, self.view.center.y, -1000)
            icon.layer.transform = iconTransform
            
            // 2. UIView animation method to change to the final state of the cell
            UIView.animate(withDuration: 1.0, animations: {
                self.icon.alpha = 1.0
                self.icon.layer.transform = CATransform3DIdentity
            })
            
            user_id.alpha = 0
            let user_idTransform = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, 0, 0, 0), self.view.center.x, self.view.center.y, -1000)
            user_id.layer.transform = user_idTransform
            
            // 2. UIView animation method to change to the final state of the cell
            UIView.animate(withDuration: 1.0, animations: {
                self.user_id.alpha = 0.3
                self.user_id.layer.transform = CATransform3DIdentity
            })
            
            password.alpha = 0
            let passwordTransform = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, 0, 0, 0), self.view.center.x, self.view.center.y, -1000)
            password.layer.transform = passwordTransform
            
            // 2. UIView animation method to change to the final state of the cell
            UIView.animate(withDuration: 1.0, animations: {
                self.password.alpha = 0.3
                self.password.layer.transform = CATransform3DIdentity
            })
            
            login.alpha = 0
            let loginTransform = CATransform3DTranslate(CATransform3DScale(CATransform3DIdentity, 0, 0, 0), self.view.center.x, self.view.center.y, -1000)
            login.layer.transform = loginTransform
            
            // 2. UIView animation method to change to the final state of the cell
            UIView.animate(withDuration: 1.0, animations: {
                self.login.alpha = 1.0
                self.login.layer.transform = CATransform3DIdentity
            })
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "Token") != nil
        {
            let Token = UserDefaults.standard.value(forKey: "Token") as? String
            let userType = UserDefaults.standard.value(forKey: "Type") as? Int
            let fullName = UserDefaults.standard.value(forKey: "FullName") as? String
            let email = UserDefaults.standard.value(forKey: "Email") as? String
            
            User.buildInstance(token: Token!, type: userType!, fullName: fullName!, email: email!)
            
            var lang : Int = 2
            
            if (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String == "ar"
            {
                lang = 2
            }
            else
            {
                lang = 1
            }
            
            let userID = UserDefaults.standard.value(forKey: "deviceID") as? String
            
            if (userID != nil){
                Request.getInstance().requestService(object: self, model: "Membership", task: "RegisterDevice", getParameters: ["access_token": Token!, "device_token": userID!, "disable": "false", "lang": "\(lang)"], postParameters: [String: String]())
            }
            if userType == 2
            {
                let childrenData = UserDefaults.standard.value(forKey: "childrenData") as? NSArray
                Children.buildInstance(data: childrenData!)
                
                self.performSegue(withIdentifier: "family", sender: nil)
            }
            else
            {
                UserDefaults.standard.set(Token, forKey: "ActiveToken")
                //perform segue
                self.performSegue(withIdentifier: "student", sender: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        if self.ActiveTextField != nil
        {
            self.ActiveTextField.resignFirstResponder()
        }
        
        let user_id = self.user_id.text
        var password = self.password.text!
        
        if Security.getInstance().isStringEmpty(user_id!)
        {
            if self.errorMessage != nil
            {
                self.errorMessage.removeFromSuperview()
                self.errorMessage = nil
            }
            
            self.errorMessage = ErrorMessageView()
            
            self.errorMessage.draw(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, message: NSLocalizedString("user_id_required", comment: ""))
            
            self.view.addSubview(self.errorMessage)
            
            //Swift 3 selector syntax
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            
            return
        }
        
        if Security.getInstance().isStringEmpty(password)
        {
            if self.errorMessage != nil
            {
                self.errorMessage.removeFromSuperview()
                self.errorMessage = nil
            }
            
            self.errorMessage = ErrorMessageView()
            
            self.errorMessage.draw(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, message: NSLocalizedString("password_required", comment: ""))
            
            self.view.addSubview(self.errorMessage)
            
            //Swift 3 selector syntax
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.removeErrorMessage), userInfo: nil, repeats: false);
            
            return
        }
        
        password = self.password.text! + passwordExtension
        
        self.user_id.isEnabled = false
        
        self.password.isEnabled = false
        
        self.login.isHidden = true
        
        loading = LoadingView()
        
        loading.draw(midX: login.center.x, midY: login.center.y, ballDim: 25, ballsCount: 5, activeColor: Colors.getInstance().colorAccent, nonActiveColor: UIColor.black.withAlphaComponent(0.3))
        
        self.view.addSubview(loading)
        
        Request.getInstance().requestService(object: self, model: "Membership", task: "Login", getParameters: ["username": user_id!, "password": Security.getInstance().md5(password)], postParameters: [String: String]())
        
        
    }
    
    override func response(task: String, dictionary: NSDictionary) {
        
        if task == "Membership/Login"
        {
            
            let ReturnData = dictionary["ReturnData"] as! NSDictionary
        
            self.token = ReturnData["Token"] as! String
            self.userType = ReturnData["Type"] as! Int
            
            var lang : Int = 2
            
            if (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as! String == "ar"
            {
                lang = 2
            }
            else
            {
                lang = 1
            }
            
            let userID = UserDefaults.standard.value(forKey: "deviceID") as? String
            if(userID != nil){
            
                   Request.getInstance().requestService(object: self, model: "Membership", task: "RegisterDevice", getParameters: ["access_token": token, "device_token": userID!, "disable": "false", "lang": "\(lang)"], postParameters: [String: String]())
            }
           
            Request.getInstance().requestService(object: self, model: "Membership", task: "Profile", getParameters: ["access_token": token], postParameters: [String: String]())
            
            Request.getInstance().requestService(object: self, model: "Messaging", task: "UnreadCount", getParameters: ["access_token": token], postParameters: [String: String]())
            
            if userType == 2
            {
                Request.getInstance().requestService(object: self, model: "Membership", task: "StudentsOfFamily", getParameters: ["access_token": token], postParameters: [String: String]())
            }
            
        }
        else if task == "Membership/RegisterDevice"
        {
            print(dictionary["ReturnData"]!)
        }
        else if task == "Membership/Profile"
        {
            let ReturnData = dictionary["ReturnData"] as! NSDictionary
            
            self.fullName = ReturnData["FullName"] as! String
            self.email = ReturnData["Email"] as! String
            
            User.buildInstance(token: token, type: userType, fullName: fullName, email: email)
            
            if userType == 1
            {
                UserDefaults.standard.set(token, forKey: "Token")
                UserDefaults.standard.set(userType, forKey: "Type")
                UserDefaults.standard.set(fullName, forKey: "FullName")
                UserDefaults.standard.set(email, forKey: "Email")
                UserDefaults.standard.set(self.token, forKey: "ActiveToken")
                //perform segue
                DispatchQueue.main.async {
             
                    self.performSegue(withIdentifier: "student", sender: nil)
                }
            }
        }
        else if task == "Membership/StudentsOfFamily"
        {
            let ReturnData = dictionary["ReturnData"] as! NSArray
            
            Children.buildInstance(data: ReturnData)
            
            UserDefaults.standard.set(token, forKey: "Token")
            UserDefaults.standard.set(userType, forKey: "Type")
            UserDefaults.standard.set(fullName, forKey: "FullName")
            UserDefaults.standard.set(email, forKey: "Email")
            UserDefaults.standard.set(ReturnData, forKey: "childrenData")
            UserDefaults.standard.set(Children.getInstance().getChildren()[0].accessToken, forKey: "ActiveToken")
            UserDefaults.standard.set(Children.getInstance().getChildren()[0].fullName, forKey: "ActiveName")
    
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "family", sender: nil)
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
        if task == "Membership/Login"
        {
            DispatchQueue.main.async {
                
                self.login.isHidden = false
                
                self.user_id.isEnabled = true
                
                self.password.isEnabled = true
                
                self.loading.removeFromSuperview()
                
                self.loading = nil
                
                if self.errorMessage != nil
                {
                    self.errorMessage.removeFromSuperview()
                    self.errorMessage = nil
                }
                
                self.errorMessage = ErrorMessageView()
                
                self.errorMessage.draw(x: 20, y: self.view.frame.height - 100, width: self.view.frame.width - 40, message: error)
                
                self.view.addSubview(self.errorMessage)
                
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
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
