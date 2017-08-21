//
//  TweetViewCell.swift
//  TwitterClient
//
//  Created by Abdullah Bayraktar on 02/08/2017.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    //MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        //No implementations at the moment.
    }
    
    //MARK: Public
    
    public func setupLogic(withModel model: TweetModel) {
        usernameLabel.text = model.username
        tweetTextLabel.text = model.text
        screenNameLabel.text = "@" + model.screenName
    }
}
