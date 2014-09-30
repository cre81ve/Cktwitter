//
//  TweetCell.swift
//  Twitter
//
//  Created by CK on 9/25/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    // Count Labels
    
    @IBOutlet weak var favCnt: UILabel!
    @IBOutlet weak var retweetCnt: UILabel!
    
    // Constraints
    
    @IBOutlet weak var selfRTConstraint: NSLayoutConstraint!
    @IBOutlet weak var selfRTLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    @IBOutlet weak var reTweetedByy: UILabel!
    @IBOutlet weak var favouritesImage: UIImageView!
    @IBOutlet weak var reTweetActionImage: UIImageView!
    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var reTweetedByImage: UIImageView!
    
    var retweetGesture:UIGestureRecognizer = UIGestureRecognizer()
    
    var tweet:Tweet = Tweet(dictionary: NSDictionary())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reTweetActionImage.userInteractionEnabled = true
        retweetGesture = UIGestureRecognizer(target: self, action: "onRetweet")
        reTweetActionImage.addGestureRecognizer(retweetGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // doesnt work from the table view because - cell select action. See detailed view for actions.
    
    func onRetweet() {
        if(tweet.retweeted > 0 ) {
            reTweetActionImage.userInteractionEnabled = false
            reTweetActionImage.setImageWithURL(NSURL(string:tweet.imageRetweeted))
        }else {
            Tweet.retweet(String(tweet.tweetId!))
            
        }
    }

}
