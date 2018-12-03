//
//  FeedViewController.swift
//  TwitterClient
//
//  Created by Abdullah Bayraktar on 29/07/2017.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    struct Constants {
        static let feedCellIdentifier = "TweetViewCell"
    }
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    var viewModel: FeedViewModel!

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = FeedViewModel()
        viewModel.delegate = self
        
        setupTableView()
        
        viewModel.startFetchingFeed()
    }
    
    //MARK: UI
    private func setupTableView() {
        
        tableView.tableFooterView = UIView()
        
        let nib = UINib(nibName: Constants.feedCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.feedCellIdentifier)
        
    }
}

//MARK: UITableView

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TweetViewCell = self.tableView.dequeueReusableCell(withIdentifier: Constants.feedCellIdentifier) as! TweetViewCell!

        let tweet = viewModel.feedArray[indexPath.row]
        cell.setupLogic(withModel: tweet)
        
        return cell
    }
}

//MARK: FeedViewModelDelegate

extension FeedViewController: FeedViewModelDelegate {
    
    func didDataReceived() {
        tableView.reloadData()
    }
}

