//
//  Payment.swift
//  LVS
//
//  Created by Jalal on 1/7/17.
//  Copyright © 2017 Abd Al Majed. All rights reserved.
//

import UIKit

class FamilyPayments: NSObject {
    private static var instance : FamilyPayments!
    
    public let studentsPayments: [StudentPayments]
    
    private init(studentsPayments: [StudentPayments]) {
        self.studentsPayments = studentsPayments
    }
    
    override init() {
        self.studentsPayments = [StudentPayments]()
    }
    
    class func getInstance() -> FamilyPayments
    {
        if instance == nil
        {
            instance = FamilyPayments()
        }
        return instance
    }
    
    func getStudentPayments(token: String) -> StudentPayments {
        
        var studentPayments: StudentPayments = StudentPayments()
        
        for item in studentsPayments {
            if item.StudentToken == token
            {
                studentPayments = item
            }
        }
        return studentPayments
    }
    
    class func buildInstance(data: NSArray)
    {
        var studentsPayments: [StudentPayments] = [StudentPayments]()
        for item in data {
            let dictionary = item as! NSDictionary
            studentsPayments.append(StudentPayments(data: dictionary))
        }
        
        instance = FamilyPayments(studentsPayments: studentsPayments)
        
    }
    
    class func destroyInstance()
    {
        instance = nil
    }
}

class StudentPayments: NSObject {
    var StudentToken: String
    var StudentName: String
    var NetTotal: Float
    var Balance: Float
    var PaymentsSum : Float
    var Payments: [Payment]
    
    override init() {
        self.StudentToken = UserDefaults.standard.value(forKey: "ActiveToken") as! String
        self.StudentName = UserDefaults.standard.value(forKey: "ActiveName") as! String
        self.NetTotal = 0.0
        self.Balance = 0.0
        self.PaymentsSum = 0.0
        
        self.Payments = [Payment]()
    }
    
    init(data: NSDictionary) {
        
        self.StudentToken = data["StudentToken"] as! String
        self.StudentName = data["StudentName"] as! String
        self.NetTotal = data["NetTotal"] as! Float
        self.Balance = data["Balance"] as! Float
        self.PaymentsSum = data["PaymentsSum"] as! Float
            
        self.Payments = [Payment]()
        
        let PaymentsData = data["Payments"] as! NSArray
        
        for item in PaymentsData {
            let PaymentData = item as! NSDictionary
            let PaymentNumber = PaymentData["PaymentNumber"] as! String
            let PaymentAmount = PaymentData["PaymentAmount"] as! Float
            let PaymentDate = PaymentData["PaymentDate"] as! String
            
            self.Payments.append(Payment(PaymentNumber: Int(PaymentNumber)!, PaymentAmount: PaymentAmount, PaymentDate: PaymentDate))
        }
        
    }
}


class Payment: NSObject {
    
    var PaymentNumber: Int
    var PaymentAmount: Float
    var PaymentDate: String
    
    init(PaymentNumber: Int, PaymentAmount: Float, PaymentDate: String) {
        self.PaymentNumber = PaymentNumber
        self.PaymentAmount = PaymentAmount
        self.PaymentDate = PaymentDate
    }
    
}




/*
 } else {
 
 JSONArray returnedData = response
 .getJSONObject(0)
 .getJSONArray("ReturnData");
 
 payments.clear();
 
 for (int i = 0; i < returnedData.length(); ++i) {
 
 String studentName = returnedData
 .getJSONObject(i)
 .getString("StudentName");
 double netTotal = returnedData
 .getJSONObject(i)
 .getDouble("NetTotal");
 double balance = returnedData
 .getJSONObject(i)
 .getDouble("Balance");
 double paymentSum = returnedData
 .getJSONObject(i)
 .getDouble("PaymentsSum");
 JSONArray payments = returnedData
 .getJSONObject(i)
 .getJSONArray("Payments");
 
 List<Payment.PaymentItem> paymentItems = new ArrayList<>();
 for (int j = 0; j < payments.length(); ++j) {
 int paymentNumber = payments
 .getJSONObject(j)
 .getInt("PaymentNumber");
 double paymentAmount = payments
 .getJSONObject(j)
 .getDouble("PaymentAmount");
 String paymentDate = payments
 .getJSONObject(j)
 .getString("PaymentDate");
 
 Payment.PaymentItem paymentItem = new Payment.PaymentItem();
 paymentItem.setDate(paymentDate);
 paymentItem.setValue(paymentAmount);
 paymentItem.setId(paymentNumber);
 
 paymentItems.add(paymentItem);
 }
 
 Payment payment = new Payment();
 payment.setStudentName(studentName);
 payment.setTotal(netTotal);
 payment.setNetTotal(balance);
 payment.setPaymentSum(paymentSum);
 payment.setPaymentItems(paymentItems);
 
 Parent.this.getPayments().add(payment);
 
 }
 */
