//
//  TwitterClient.swift
//  Twitter
//
//  Created by CK on 9/26/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

let consumerKey = "9DUa1opInxT6NE09QLGDhI8Qv"
let consumerSecret = "Mmm5iZgu6qw1z1kH2vCMm6D8Uhncs2NN3FQAnojI1Rzig0eS8G"
let twitterURL = NSURL(string:"https://api.twitter.com")
let twitterPostUrl = "1.1/statuses/update.json"
let twitterRetweetUrl = "1.1/statuses/retweet/:id.json"
let twitterFavUrl = "1.1/favorites/create.json"

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion :((user:User?, error:NSError?) -> ())?
    
    // Singleton - shared instance
    
    class var sharedInstance: TwitterClient{
    struct Static {
        static let instance = TwitterClient(baseURL: twitterURL, consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        }
        return Static.instance
    }
    
    
    // Client for home time line
    
    func tweetsHomeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?,error: NSError?)-> ()) {
        NSLog(" params \(params)")
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets : tweets ,error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(" Error   \(error)")
                completion(tweets : nil ,error: error)
        })
        
    }
    
    
    // Client for login
    
    func loginWithCompletion(completion: (user:User?, error:NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch token
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string:"cktwitterdemo://oauth"),
            scope: nil,
            success: {
                (requestToken: BDBOAuthToken!) -> Void in
                println("Successful Login")
                var authUrl = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authUrl)
                
            }){
                (error: NSError!) -> Void in
                println("Error Login")
                
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    
    
    // Client for auth (Oauth 1.0 )
    
    func openUrl(url:NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                self.loginCompletion?(user: user, error: nil)
                User.currentUser = user
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println(" Error   \(error)")
                    self.loginCompletion?(user: nil, error: error)
            })
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            }) { (error:NSError!) -> Void in
                println("Error in getting access Token \(error)")
                self.loginCompletion?(user: nil, error: error)
                
        }
        
    }
    
    
    
    // Tweet Client
    
    func updateStatus(text: String) {
        var status = ["status" : text]
        
        TwitterClient.sharedInstance.POST(twitterPostUrl, parameters: status, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error .. \(error)")
        }
    }
    
    
    // Retweet Client
    
    func reTweet(tweetid: String) {
        var idParams = ["id" : tweetid]
        
        var twitterRetweetUrlReplaced = twitterRetweetUrl.stringByReplacingOccurrencesOfString(":id", withString: tweetid, options: nil, range: nil)
        TwitterClient.sharedInstance.POST(twitterRetweetUrlReplaced, parameters: idParams, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Retweeted to post is \(response)")
            }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error .. \(error)")
        }
    }
    
    
    // Reply Client
    
    func rePly(status: String , inReplyId:String) {
        var idParams = ["status" : status,"in_reply_to_status_id": inReplyId]
        
        TwitterClient.sharedInstance.POST(twitterPostUrl, parameters: idParams, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Replied to post is \(response)")
            }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error .. \(error)")
        }
    }
    
    
    // Favorite Client
    
    func favourite(tweetid: String) {
        var idParams = ["id" : tweetid]
        
        TwitterClient.sharedInstance.POST(twitterFavUrl, parameters: idParams, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Favourited to post is \(response)")
            }) { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error .. \(error)")
        }
    }
    
}
