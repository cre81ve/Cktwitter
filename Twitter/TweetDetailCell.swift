//
//  TweetDetailCell.swift
//  Twitter
//
//  Created by CK on 9/28/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {

    @IBOutlet weak var selfRTLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var selfRTConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetTime: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var reTweetedImage: UIImageView!
    @IBOutlet weak var reTweetedByLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
