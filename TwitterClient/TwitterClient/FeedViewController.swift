//
//  FeedViewController.swift
//  TwitterClient
//
//  Created by Abdullah Bayraktar on 29/07/2017.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    var client: OAuthClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
         client = OAuthClient(
            consumerKey: "KyIw4wZpfx6SaAv1h5BlkOF27",
            consumerSecret: "jUIUrZ9HoIiM95UfnFDTLm6sWvn0nzSleoJCN5TsdWiNmzlIuA",
            accessToken: "108780631-XgV4Cs9Tc5YrwUVIRguTlR58gvRxz4FWTaQr7TLO",
            accessTokenSecret: "kQf9hNyDTGDat0PRq9KCNf9QHArBwD11a3gcEI4HKwcDT")
        
        var parameters = [String: String]()
        parameters["track"] = "Game of Thrones"
        
        let request = client?
            .streaming("https://stream.twitter.com/1.1/statuses/filter.json", parameters: parameters)
            .progress({ (data) in
                let json = JSON(data: data)
                print(json)
            })
            .completion({ (data, urlResponse, error) in
                if (error != nil) {
                    print(error.debugDescription)
                }
            })
            .start()

        
        // disconnect
        //request?.stop()
        
    }
    
    private func setupTableView() {
        
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: "TweetViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TweetViewCell")
        
    }
}

//MARK: UITableView

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TweetViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TweetViewCell") as! TweetViewCell!
        //cell.delegate = self
        
        cell.setupLogic(withText: "bla bla")
        
        return cell
    }
}


