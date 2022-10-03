//
//  NSObjectExtenssion.swift
//  LVS
//
//  Created by Jalal on 12/11/16.
//  Copyright © 2016 Abd Al Majed. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    @objc func response(task: String, dictionary: NSDictionary) { }
    
    @objc func responseFault(task: String, error: String)
    {
        print(error)
    }
    
    @objc func enableViewWithRefresh()
    {
        
    }
    
    @objc func enableView()
    {
        
    }
    
    @objc func deleteMail(messageID: String)
    {
       
    }
    
}
extension String {
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions: [String : Any] = [
            convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html),
            convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.characterEncoding): String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary(attributedOptions), documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

class InsetLabel: UILabel {
    
    
    override func drawText(in rect: CGRect) {
        self.layoutIfNeeded()
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)))
    }
}

/*extension UILabel {
    
    func drawText(in rect: CGRect) {
        let topInset: CGFloat = 5.0
        let bottomInset: CGFloat = 5.0
        let leftInset: CGFloat = 5.0
        let rightInset: CGFloat = 5.0
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            let topInset: CGFloat = 5.0
            let bottomInset: CGFloat = 5.0
            let leftInset: CGFloat = 5.0
            let rightInset: CGFloat = 5.0
            
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}*/

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

