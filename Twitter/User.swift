//
//  User.swift
//  Twitter
//
//  Created by CK on 9/27/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    // user initialization with JSON Dictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.screenName = dictionary["screen_name"] as? String
        self.name = dictionary["name"] as? String
        self.profileImageUrl = dictionary["profile_image_url"] as? String
        self.tagline = dictionary["description"] as? String
        
    }
    
    
    // Logout function for user
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    
    // Lgin function notification
    
    func login() -> Bool{
        var success:Bool = false
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User? ,error:NSError?) in
            
            if user != nil {
                NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
                success = true
            }
            else {
                //handle login error
                success = false
            }
        }
        
        return success
        
    }
    
    class var currentUser: User? {
        
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if(data != nil) {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
                
        set(user) {
            _currentUser = user
            if(_currentUser != nil) {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            }else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        
    }
    
}
