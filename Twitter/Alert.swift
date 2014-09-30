//
//  Alert.swift
//  Twitter
//
//  Created by CK on 9/29/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class Alert: NSObject {
 
    
    
    override init(){
        super.init()
    }
    
    
    var alertView:UIAlertView = UIAlertView()

    func show(message: String , timeout: Double) {
        alertView = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: nil)
        alertView.show()
        NSTimer.scheduledTimerWithTimeInterval(timeout, target: self, selector: "expire", userInfo: nil, repeats: false)
        
    }
    
    func expire() {
        alertView.dismissWithClickedButtonIndex(0, animated: true)
    }
    
}
