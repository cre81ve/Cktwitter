//
//  TweetListViewController.swift
//  Twitter
//
//  Created by CK on 9/25/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class TweetListViewController: UIViewController ,UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var retweetCnt: UILabel!
    
    @IBOutlet weak var favCnt: UILabel!
    
    @IBOutlet var replyGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var reTweetGesture: UIImageView!
    
    @IBOutlet weak var favouriteGesture: UIImageView!
    
    @IBOutlet weak var tweetsTable: UITableView!
    var tweets = [Tweet]()
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    var counter:Int? = 20
    var called:Bool = false
    var dicParams:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTable.delegate = self
        tweetsTable.dataSource = self
        tweetsTable.rowHeight = UITableViewAutomaticDimension
        dicParams = ["count" : "100"]

        tweetsTable.hidden = true
        refreshTweets()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refreshTweets", forControlEvents: UIControlEvents.ValueChanged)
        self.tweetsTable.insertSubview(refreshControl, atIndex: 0)
        Store.store("reply.name", val: "")
        Store.store("reply.id" , val: "")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(true)
        refreshTweets()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        Store.store("reply.name", val: "")
        Store.store("reply.id" , val: "")
        
    }
    
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func refreshTweets() {
        refreshTweetsWithParams(dicParams)
    }
    
    func refreshTweetsWithParams(params:NSDictionary) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Tweet.tweetsHomeTimeLineWithParams(params, completion: { (tweets, error) -> () in
            if(tweets != nil) {
                self.tweets = tweets!
                for tw in tweets! {
                    var t = tw as Tweet
                }
                self.tweetsTable.reloadData()
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.tweetsTable.hidden = false
            }
            else {
                NSLog("Error in loading tweets")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        var tvc = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as UIViewController
        self.presentViewController(tvc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func onReply(sender: AnyObject) {
        
    }
    
    
    @IBAction func onFavourite(sender: AnyObject) {
        
        
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
    }
    
    @IBOutlet var onFavourite: UITapGestureRecognizer!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tc:TweetCell = tableView.dequeueReusableCellWithIdentifier("tweetCellId") as TweetCell
        if(tweets.count > 0 ) {
            var tweet:Tweet = tweets[indexPath.row] as Tweet
            var user:User =  tweet.user!
            tc.tweetText.text = tweet.text
            var profileImageUrl = user.profileImageUrl
            var retweeted:Bool = false
            var userscreenname = user.screenName
            var userfullname = user.name
            if((tweet.originalUser) != nil) {
                retweeted = true
            }
            if(retweeted) {
                profileImageUrl = tweet.originalUser?.profileImageUrl
                userfullname = tweet.originalUser?.name
                userscreenname = tweet.originalUser?.screenName
                NSLog(" Retweeted post by \(userscreenname)")
            }else {
                NSLog(" Normal post by \(userscreenname)")
                
            }
            tc.userProfileImage.setImageWithURL(NSURL(string: profileImageUrl!))
            tc.userFullName.text = userfullname
            tc.userName.text = userscreenname
            tc.tweet = tweet
            
            if((tweet.user) != nil && retweeted ) {
                tc.reTweetedByImage.setImageWithURL(NSURL(string:tweet.imageRetweeted))
                tc.reTweetedByy.text = tweet.user?.name
                showRetweeted(tc)
            }else {
               hideRetweeted(tc)
                
            }
            tc.replyImage.setImageWithURL(NSURL(string:tweet.imageReply))
            tc.reTweetActionImage.setImageWithURL(NSURL(string:tweet.imageRetweet))
            tc.favouritesImage.setImageWithURL(NSURL(string:tweet.imageFavourite))
            tc.retweetCnt.text = String(tweet.retweetCount!)
            tc.favCnt.text = String(tweet.favouriteCount!)
            if(tweet.favourited > 0) {
                tc.favouritesImage.setImageWithURL(NSURL(string:tweet.imageFavouriteOn))
            }
            if(tweet.retweeted > 0) {
                tc.reTweetActionImage.setImageWithURL(NSURL(string:tweet.imageRetweeted))
            }
            tc.timeSinceLabel.text = tweet.createdAt?.prettyTimestampSinceNow()
        }
        return tc
    }
    
    
    func hideRetweeted(tc: TweetCell) {
        //CONSTRAINT STUFF
        tc.selfRTConstraint.constant = 0
        tc.selfRTLabelConstraint.constant = 0
        tc.reTweetedByy.hidden = true
        tc.reTweetedByImage.hidden = true
    }
    
    func showRetweeted(tc: TweetCell) {
        //CONSTRAINT STUFF
        tc.selfRTConstraint.constant = 15
        tc.selfRTLabelConstraint.constant = 14
        tc.reTweetedByy.hidden = false
        tc.reTweetedByImage.hidden = false
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tweetSelected = tweets[indexPath.row] as Tweet
        Tweet.currentTweet = tweetSelected
        var tdc = self.storyboard?.instantiateViewControllerWithIdentifier("tweetDetailController") as TweetDetailController
        var segue = UIStoryboardSegue(identifier: "tweetDetailSegue", source: self, destination: tdc)
        self.prepareForSegue(segue, sender: self)
    }
    
    
    
    @IBAction func onShowCompose(sender: AnyObject) {
        var tdc = self.storyboard?.instantiateViewControllerWithIdentifier("newTweetController") as NewTweetController
        var segue = UIStoryboardSegue(identifier: "tweetComposeSegue", source: self, destination: tdc)
        self.prepareForSegue(segue, sender: self)
        
    }
    
    // infinite scroll.
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        var actual:CGFloat = scrollView.contentOffset.y
//        var contentHeight:CGFloat = scrollView.contentSize.height - 5
//        NSLog("Actual is \(actual) , Height is \(contentHeight)")
//        if(actual >= contentHeight/2 && !called) {
//            counter = counter! + 100
//            NSLog("Calling refresh on scroll....")
//            refreshTweetsWithParams(["count": String(counter!)])
//            called = true
//            dicParams = ["count" : counter!]
//        }
//    }
//    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
