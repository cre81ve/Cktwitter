//
//  TweetActionCell.swift
//  Twitter
//
//  Created by CK on 9/28/14.
//  Copyright (c) 2014 Chaitanya Kannali. All rights reserved.
//

import UIKit

class TweetActionCell: UITableViewCell {

    @IBOutlet weak var replyImage: UIImageView!
    @IBOutlet weak var reTweetImage: UIImageView!
    @IBOutlet weak var favouriteImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
