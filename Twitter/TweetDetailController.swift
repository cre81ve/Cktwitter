//
//  TweetDetailController.swift
//  Twitter
//
//  Created by CK on 9/28/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class TweetDetailController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet var replyGesture: UITapGestureRecognizer!
    @IBOutlet var reTweetGesture: UITapGestureRecognizer!
    @IBOutlet var favouriteGesture: UITapGestureRecognizer!
    @IBOutlet weak var tableDetailView: UITableView!
    
    var current:Tweet = Tweet(dictionary: NSDictionary())
    var counterCell:TweetCountCell = TweetCountCell()
    var actionCell:TweetActionCell = TweetActionCell()
    
    var favAlert:Alert = Alert()
    var retAlert:Alert = Alert()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        current = Tweet.currentTweet!
        tableDetailView.delegate = self
        tableDetailView.dataSource = self
        tableDetailView.rowHeight = UITableViewAutomaticDimension
        tableDetailView.reloadData()
        Store.store("reply.name", val: "")
        Store.store("reply.id" , val: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // Action on tap reply image icon
    
    @IBAction func onReply(sender: AnyObject) {
        var tdc = self.storyboard?.instantiateViewControllerWithIdentifier("newTweetController") as NewTweetController
        self.navigationController?.pushViewController(tdc, animated: true)
        Store.store("reply.id", val: String(current.tweetId!))
        Store.store("reply.name",val: (current.user?.screenName)!)
    }
    
    
    // Action on tap of retweet
    
    @IBAction func onRetweet(sender: AnyObject) {
        var tweetId = String((current.tweetId!))
        Tweet.retweet(tweetId)
        actionCell.reTweetImage.setImageWithURL(NSURL(string: current.imageRetweeted))
        var rtcount = counterCell.reTweetCount.text?.toInt()
        counterCell.reTweetCount.text = String(rtcount!+1)
        retAlert.show("Retweeted", timeout: 1)
        retAlert.expire()
    }
    
    
    // Action on tap of favorite
    
    @IBAction func onFavourite(sender: AnyObject) {
        var tweetId = String((current.tweetId!))
        Tweet.favourite(tweetId)
        actionCell.favouriteImage.setImageWithURL(NSURL(string: current.imageFavouriteOn))
        var favcount = counterCell.favouriteCount.text?.toInt()
        counterCell.favouriteCount.text = String(favcount!+1)
        favAlert.show("Favorited", timeout: 1)
        favAlert.expire()
    }
    
    // Pops back to home (tweet list)
    
    @IBAction func goHome(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    // Action on Reply Button on Bar Button - Nav
    
    @IBAction func onReplyNav(sender: AnyObject) {
        var tdc = self.storyboard?.instantiateViewControllerWithIdentifier("newTweetController") as NewTweetController
        self.navigationController?.pushViewController(tdc, animated: true)
        Store.store("reply.id", val: String(current.tweetId!))
        Store.store("reply.name",val: (current.user?.screenName)!)
    }
    
    
    // Renders 3 rows - (Detail , Count , Action ) Cells.
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var user = current.user
        switch indexPath.row {
        case 0 :
            var dc = tableView.dequeueReusableCellWithIdentifier("detailCellId") as TweetDetailCell
            user = current.user
            var profileurl = user?.profileImageUrl
            var userfullname = user?.name
            var userscreenname = user?.screenName
            var retweetedd:Bool = false
            if((current.originalUser) != nil) {
                retweetedd = true
            }
            if(retweetedd) {
                profileurl = current.originalUser?.profileImageUrl
                userfullname = current.originalUser?.name
                userscreenname = current.originalUser?.screenName
            }
            dc.userProfileImage.setImageWithURL(NSURL(string: profileurl!))
            dc.userName.text = userscreenname
            dc.userFullName.text = userfullname
            dc.tweetText.text = current.text
            dc.tweetTime.text = current.createdAtString
            if((current.user) != nil  && retweetedd) {
                dc.reTweetedByLabel.text = (current.user?.name)! + " retweeted"
                dc.reTweetedImage.setImageWithURL(NSURL(string:current.imageRetweeted))
                dc.reTweetedByLabel.hidden = false
                dc.reTweetedImage.hidden = false
            }
            else {
                dc.reTweetedByLabel.hidden = true
                dc.reTweetedImage.hidden = true
            }
            
            return dc
            
            
        case 1:
            var cc = tableView.dequeueReusableCellWithIdentifier("countCellId") as TweetCountCell
            counterCell = cc
            cc.reTweetCount.text = String(current.retweetCount!)
            cc.favouriteCount.text = String(current.favouriteCount!)
            return cc
            
            
        case 2:
            var ac = tableView.dequeueReusableCellWithIdentifier("actionCellId") as TweetActionCell
            ac.replyImage.setImageWithURL(NSURL(string:current.imageReply))
            if(current.favourited! > 0 ) {
                ac.favouriteImage.setImageWithURL(NSURL(string:current.imageFavouriteOn))
                ac.favouriteImage.userInteractionEnabled = false
            }else {
                ac.favouriteImage.setImageWithURL(NSURL(string:current.imageFavourite))
            }
            
            if(current.retweeted! > 0 ) {
                ac.reTweetImage.setImageWithURL(NSURL(string:current.imageRetweeted))
                ac.reTweetImage.userInteractionEnabled = false
            }else {
                ac.reTweetImage.setImageWithURL(NSURL(string:current.imageRetweet))
                
            }
            actionCell = ac
            return ac
        default :
            
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
