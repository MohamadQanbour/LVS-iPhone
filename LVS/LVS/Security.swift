//
//  File.swift
//  LittleVillageSchool
//
//  Created by Jalal on 12/10/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Security: NSObject {
    
    private static let instance : Security = Security()
    
    let query : String = "membership"
    let secret : String = "lvssecuritykey"
    let url : String = "https://app.littlevillageschool.com/ajax/"
    
    private override init() {

    }
    
    class func getInstance() -> Security
    {
        return instance
    }
    
    private func refactorParameter(parameter: String) -> String
    {
        var newParameter = parameter.replacingOccurrences(of: " ", with: "+")
        newParameter = parameter.replacingOccurrences(of: " ", with: "%20")
        return newParameter
    }
    
   
    
    func md5(_ string: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        if let data = string.data(using: String.Encoding.utf8) {
            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    
    
    private func getSecretKey(parameters: [String: String]) -> String {
        
        var allParameters = parameters
        
        allParameters["query"] = query
        
        for (_ , var value) in allParameters {
            value = refactorParameter(parameter: value)
        }
        
        let sortedKeys = allParameters.keys.sorted(by: {$0 < $1})
        
        var secretKey = secret
        
        for key in sortedKeys {
            secretKey = secretKey + allParameters[key]!
        }
        
        secretKey = secretKey.lowercased()
        
        secretKey = md5(secretKey)
        
        return secretKey
    }
    
    func createPostRequest(parameters: [String: String]) -> String
    {
        var resultString : String = "query=membership"
        
        for (key, value) in parameters {
            resultString = resultString + "&" + key + "=" + value
        }
        
        return resultString
    }
    
    func getURL(model: String, task: String, getParameters: [String: String], postParameters: [String: String]) -> String
    {
        var url = self.url + model + "/" + task + "?"
        
        for (key , value) in getParameters {
            url = url + key + "=" + value + "&"
        }
        
        var parameters = getParameters;
        
        for (key , value) in postParameters {
            parameters[key] = value
        }
        
        url = url + "security_key=" + getSecretKey(parameters: parameters)
        
        return url
        
    }
    
    func isStringEmpty(_ stringValue:String) -> Bool
    {
        if stringValue.isEmpty  == true
        {
            
            return true
        }
        
        return false
        
    }

}
