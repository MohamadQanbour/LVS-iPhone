//
//  ChildrenList.swift
//  LVS
//
//  Created by Jalal on 12/29/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import UIKit

class ChildrenList: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var choseChildren: UILabel!
    @IBOutlet weak var childrenTV: UITableView!
    @IBOutlet weak var heightConstrant: NSLayoutConstraint!
    
    var parentObject: NSObject!
    
    let childrenList = Children.getInstance().getChildren()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        self.childrenTV.delegate = self
        self.childrenTV.dataSource = self
        
        if childrenList.count <= 3
        {
            heightConstrant.constant = CGFloat(38 + 6 +  childrenList.count * 52)
            
        }
        else
        {
            heightConstrant.constant = CGFloat(38 + 6 +  3 * 52)
            
        }
        
        background.backgroundColor = Colors.getInstance().colorBackground
        
        background.layer.cornerRadius = 3.0
        
        choseChildren.layer.cornerRadius = 3.0
        
        choseChildren.text = NSLocalizedString("chose_child", comment: "")
        
        choseChildren.textColor = UIColor.white
        
        choseChildren.backgroundColor = Colors.getInstance().colorPrimary
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.removeAnimate))
        
        self.mainBackground.addGestureRecognizer(tap)
        
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimateWithRefresh()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    _ = self.navigationController?.popViewController(animated: false)
                    self.parentObject.enableViewWithRefresh()
                    self.view.removeFromSuperview()
                }
        });
    }
    
    @objc func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    _ = self.navigationController?.popViewController(animated: false)
                    self.parentObject.enableView()
                    self.view.removeFromSuperview()
                }
        });
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.childrenList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Child Cell", for: indexPath)
        
        cell.contentView.backgroundColor = Colors.getInstance().colorBackground
        
        let child = self.childrenList[(indexPath as NSIndexPath).row]
       
        let name = cell.viewWithTag(1) as! UILabel
        
        
        name.text = child.fullName
        
        if (indexPath.row == childrenList.count - 1)
        {
            let separator = cell.viewWithTag(2) as! UILabel
            separator.isHidden = true
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newToken = self.childrenList[indexPath.row].accessToken
        let oldToken = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        
        if newToken.compare(oldToken) != ComparisonResult.orderedSame
        {
            UserDefaults.standard.set(self.childrenList[indexPath.row].accessToken, forKey: "ActiveToken")
            UserDefaults.standard.set(self.childrenList[indexPath.row].fullName, forKey: "ActiveName")
            
            self.removeAnimateWithRefresh()
        }
        else
        {
            self.removeAnimate()
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIView = (scrollView.subviews[(scrollView.subviews.count - 1)] )
        verticalIndicator.backgroundColor = Colors.getInstance().colorAccent
        
    }

}
