//
//  Tweet.swift
//  Twitter
//
//  Created by CK on 9/27/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

var _currentTweet: Tweet?
let currentTweetKey = "kCurrentTweetKey"


class Tweet: NSObject {
    
    
    
    // tweet related image urls
    
    let imageRetweet = "https://si0.twimg.com/images/dev/cms/intents/icons/retweet.png"
    let imageFavourite = "https://si0.twimg.com/images/dev/cms/intents/icons/favorite.png"
    let imageFavouriteOn = "https://si0.twimg.com/images/dev/cms/intents/icons/favorite_on.png"
    let imageReply = "https://si0.twimg.com/images/dev/cms/intents/icons/reply.png"
    let imageRetweeted = "https://si0.twimg.com/images/dev/cms/intents/icons/retweet_on.png"
   
    // Tweet data model
    
    var user:User?
    var text:String?
    var createdAtString: String?
    var createdAt:NSDate?
    var tweetId:Int?
    var tweetDictionary:NSDictionary
    var retweetCount:Int?
    var favouriteCount:Int?
    var favourited:Int?
    var retweeted:Int?
    var originalUser:User?
   
    // initialize with JSON Dictionary
    
    init(dictionary:NSDictionary) {
        if(dictionary.count > 0 ) {
            self.user = User(dictionary: dictionary["user"] as NSDictionary)
            self.text = dictionary["text"] as? String
            self.createdAtString = dictionary["created_at"] as? String
            var formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss z y"
            createdAt = formatter.dateFromString(createdAtString!)
            tweetDictionary = dictionary
            tweetId = dictionary["id"] as? Int
            retweetCount = dictionary["retweet_count"] as? Int
            favouriteCount = dictionary["favorite_count"] as? Int
            favourited = dictionary["favorited"] as? Int
            retweeted = dictionary["retweeted"] as? Int
            if((dictionary["retweeted_status"]) != nil) {
                var retweeted_status = dictionary["retweeted_status"] as NSDictionary
                var ou = retweeted_status["user"] as NSDictionary
                originalUser = User(dictionary: ou)
            }
        }
        tweetDictionary = dictionary
    }
    
  
    // Tweets with array
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    
    
    // Tweets home time line - returns Array
    
     class func tweetsHomeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?,error: NSError?)-> ())
     {
        TwitterClient.sharedInstance.tweetsHomeTimeLineWithParams(params, completion: completion);
     }
    
    // Tweet 
    
    class func post(text: String) {
        TwitterClient.sharedInstance.updateStatus(text)
    }
    
    
    // ReTweet
    
    class func retweet(id:String) {
        TwitterClient.sharedInstance.reTweet(id)
    }
    
    // Favorite
    
    class func favourite(id:String) {
        TwitterClient.sharedInstance.favourite(id)
    }
    
    // Reply to a tweet
    
    class func reply(text:String , inReplyToId: String) {
        TwitterClient.sharedInstance.rePly(text, inReplyId: inReplyToId)
    }
    
    
    // Current tweet selected to detailed view.
    
    class var currentTweet: Tweet? {
        
        get {
            if _currentTweet == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentTweetKey) as? NSData
                if(data != nil) {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentTweet = Tweet(dictionary: dictionary)
                }
            }
        return _currentTweet
        }
        
        set(tweet) {
           
            _currentTweet = tweet
            
                if(_currentTweet != nil) {
                    var data = NSJSONSerialization.dataWithJSONObject(tweet!.tweetDictionary, options: nil, error: nil)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentTweetKey)
                }else {
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentTweetKey)
                }
                NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        
    }
  
    
}
