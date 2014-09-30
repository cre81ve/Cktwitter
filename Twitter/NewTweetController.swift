//
//  NewTweetController.swift
//  Twitter
//
//  Created by CK on 9/28/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class NewTweetController: UIViewController ,UITextViewDelegate {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var composedTweetText: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    
    var inReplyToUser = ""
    var inReplyToTweetId = ""
    
    var alert:Alert = Alert()
    var remainingTextZero = ""
    var tweetText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentUser = User.currentUser
        var profileUrl = currentUser?.profileImageUrl
        userProfileImage.setImageWithURL(NSURL(string: profileUrl!))
        userName.text = currentUser?.screenName
        userFullName.text = currentUser?.name
        composedTweetText.delegate = self
        composedTweetText.text = ""
        composedTweetText.becomeFirstResponder()
        inReplyToUser  = Store.retrieve("reply.name") as String
        inReplyToTweetId = Store.retrieve("reply.id") as String
        if(countElements(inReplyToTweetId) > 0 ) {
            composedTweetText.text = "@" + inReplyToUser + " "
        }
        
    }
    
    
    // Counts number of characters remaining in a tweet.
    
    func textViewDidChange(textView: UITextView) {
        var text =     textView.text
        tweetText = text
        var count = countElements(text)
        var remainingCount = 140 - count
        characterCount.text = "" + String(remainingCount)
        if(remainingCount == 0 ) {
            remainingTextZero = text
        }
        if(remainingCount < 1 ) {
            textView.text = remainingTextZero
            showAlert("140 Character Limit Reached",timeout: 1)
            characterCount.text = "" + String(0)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Action to post a Tweet
    
    @IBAction func onTweet(sender: AnyObject) {
        if(countElements(inReplyToTweetId) > 0 ) {
            Tweet.reply(tweetText, inReplyToId: inReplyToTweetId)
        } else {
            Tweet.post(tweetText)
        }
        backToHome()
    }
    
    
    // two methods below - A temp alert to show  - 140 characters are over .
    
    func showAlert(message: String , timeout: Double) {
        alert.show(message, timeout: timeout)
    }
    
    func timerExpired() {
        alert.expire()
    }
    
    
    // On cancel pop it back home
    
    @IBAction func onCancel(sender: AnyObject) {
        backToHome()
        
    }
    
    // Pop to home of tweet list.
    
    func backToHome() {
        self.navigationController?.popToRootViewControllerAnimated(true)
        Store.store("reply.name", val: "")
        Store.store("reply.id" , val: "")
    }
    
  
    
}
