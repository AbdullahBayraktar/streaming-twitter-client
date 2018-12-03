//
//  TweetModel.swift
//  TwitterClient
//
//  Created by Abdullah Bayraktar on 03/08/2017.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import SwiftyJSON

class TweetModel: NSObject {
    
    var text: String
    var username: String
    var screenName: String
    
    required init(jsonData: JSON) {
        
        self.text = jsonData["text"].stringValue
        self.username = jsonData["user"]["name"].stringValue
        self.screenName = jsonData["user"]["screen_name"].stringValue
    }
}
