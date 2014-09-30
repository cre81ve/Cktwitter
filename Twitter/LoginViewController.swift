//
//  LoginViewController.swift
//  Twitter
//
//  Created by CK on 9/26/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // On click of login button 
    
    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User? ,error:NSError?) in
            
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else {
            }
        }
    }
    
}
