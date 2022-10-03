//
//  Request.swift
//  LittleVillageSchool
//
//  Created by Jalal on 12/11/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import Foundation

class Request {
    
    private static let instance : Request = Request()
    
    private init() {
        
    }
    
    class func getInstance() -> Request
    {
        return instance
    }
    
    func requestService(object: NSObject, model: String, task: String, getParameters: [String: String], postParameters:[String: String]) {
        
        let url = Security.getInstance().getURL(model: model, task: task, getParameters: getParameters, postParameters: postParameters)
        
        MakeRequest(url: url, postParameters: Security.getInstance().createPostRequest(parameters: postParameters),  object: object, model: model, task: task)
        
    }
    
    private func MakeRequest(url: String, postParameters: String, object: NSObject, model: String, task: String) {
        
        let myUrl = URL(string: url);
        let cahs = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        let request = NSMutableURLRequest(url:myUrl!, cachePolicy: cahs, timeoutInterval: 5.0);
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy(rawValue: 10)!
        
        let param = postParameters.data(using: .utf8)
        
        request.httpBody = param
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                print(error.debugDescription)
                print(error?.localizedDescription)
                object.responseFault(task: model + "/" + task, error: (error?.localizedDescription)!)
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString!)")
            
            // Convert server json response to NSDictionary
            do {
                let resultArray = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                
                let dictionary = resultArray[0] as! NSDictionary
                
                if((dictionary["HasError"] as! Bool) != true)
                {
                    object.response(task: model + "/" + task, dictionary: dictionary)
                }
                else{
                    object.responseFault(task: model + "/" + task, error: dictionary["ErrorMessage"] as! String)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        })
        
        task.resume()
    }
    
    /*class func download(attachment: Attachment, object: MailDetails) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: object, delegateQueue: nil)
        
        let myUrl = URL(string: attachment.FilePath);
        let cahs = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        var request = URLRequest(url:myUrl!, cachePolicy: cahs);
        
        request.cachePolicy = NSURLRequest.CachePolicy(rawValue: 10)!
        request.httpMethod = "GET"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let filePath="\(documentsPath)/appLittleVillageSchool/tempAttachment.\(attachment.FileType)";
        let alert: UIAlertView = UIAlertView()
        var message: String!
    
        let downloadTask = session.downloadTask(with: myUrl!)
        
        downloadTask.resume()
        
        /*let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                
                let fileManager = FileManager.default
                
                var error : NSError?
                do {
                    try fileManager.copyItem(atPath: tempLocalUrl.absoluteString, toPath: filePath)
                } catch let error1 as NSError {
                    error = error1
                }
                if (error != nil) {
                    message = error?.localizedDescription
                    
                    alert.title = "Error Occured"
                    alert.delegate = nil
                    alert.addButton(withTitle: "Ok")
                    alert.show()
                } else {
                    //response
                    message = "DownloadingFile Successfully"
                }
                
                print(filePath)
                print(tempLocalUrl)
                
            } else {
                message = error?.localizedDescription
            }
        }
        task. = object
        task.resume()
        task.cancel { (nil) in
            
        }*/
    }*/

}
