//
//  FeedViewModel.swift
//  TwitterClient
//
//  Created by Abdullah Bayraktar on 02/08/2017.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol FeedViewModelDelegate: class {
    func didDataReceived()
}

class FeedViewModel: NSObject {

    struct Constants {
        struct TwitterAuth {
            static let consumerKey = "KyIw4wZpfx6SaAv1h5BlkOF27"
            static let consumerSecret = "jUIUrZ9HoIiM95UfnFDTLm6sWvn0nzSleoJCN5TsdWiNmzlIuA"
            static let accessToken = "108780631-XgV4Cs9Tc5YrwUVIRguTlR58gvRxz4FWTaQr7TLO"
            static let accessTokenSecret = "kQf9hNyDTGDat0PRq9KCNf9QHArBwD11a3gcEI4HKwcDT"
        }
        
        static let streamingEndpoint = "https://stream.twitter.com/1.1/statuses/filter.json"
        static let numberOfLatestTweetsToBeShown = 5
    }
    
    //MARK: Properties
    
    private var oAuthClient: OAuthClient?
    var feedArray: [TweetModel] = []
    
    //MARK: Delegates
    
    weak var delegate: FeedViewModelDelegate?
    
    //MARK: Public Methods
    
    func startFetchingFeed() {
        
        oAuthClient = OAuthClient(
            consumerKey: Constants.TwitterAuth.consumerKey,
            consumerSecret: Constants.TwitterAuth.consumerSecret,
            accessToken: Constants.TwitterAuth.accessToken,
            accessTokenSecret: Constants.TwitterAuth.accessTokenSecret)
        
        let parameters: [String: String] = ["track": "game of thrones"]
        
        oAuthClient?.streaming(Constants.streamingEndpoint, parameters: parameters)
            .progress({ [weak self](data) in
                let json = JSON(data: data)
                let tweet = TweetModel(jsonData: json)
            
                if let tweetsCount = self?.feedArray.count {
                    
                    if tweetsCount >= Constants.numberOfLatestTweetsToBeShown {
                        self?.feedArray.remove(at: tweetsCount-1)
                        self?.feedArray.insert(tweet, at: 0)
                    }
                    else {
                        self?.feedArray.insert(tweet, at: 0)
                    }
                }

                DispatchQueue.main.async {
                    self?.delegate?.didDataReceived()
                }
                //Print for debug
                //print(json)
            })
            .completion({ (data, urlResponse, error) in
                if (error != nil) {
                    print(error.debugDescription)
                }
            })
            .start()
    }
}
