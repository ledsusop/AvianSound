//
//  TweetsViewController.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var tweets:[Tweet]!
    var currentSelectedTweet:Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshControl.addTarget(self, action: #selector(self.loadData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(self.refreshControl)
        
        loadData(nil)
    }
    
    @IBAction func onLogoutBtnClick(sender: UIBarButtonItem) {
        AvianSoundClient.sharedClient.logout()
    }
    
    @IBAction func onNewTweet(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("composeSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.currentSelectedTweet = self.tweets[indexPath.row]
        self.performSegueWithIdentifier("tweetDetailsSegue", sender: self)
        
    }

    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetTableCell", forIndexPath: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func loadData(refreshControl:UIRefreshControl?){
        
        if refreshControl != nil {
            refreshControl!.endRefreshing()
        }
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        AvianSoundClient.sharedClient.homeTimeline({ (tweets: [Tweet]) -> () in
            
            self.currentSelectedTweet = nil
            self.tweets = tweets
            
            for tweet in self.tweets {
                print(tweet.text)
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.reloadData()
            
            }, failure:  { (error: NSError!) -> () in
                
                print("error: \(error.localizedDescription)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destinationController = segue.destinationViewController.childViewControllers[0] as? ComposeTweetViewController{
            destinationController.firstViewController = self
            
        }else if let destinationController = segue.destinationViewController.childViewControllers[0] as? TweetDetailsViewController {
            destinationController.firstViewController = self
            destinationController.tweet = self.currentSelectedTweet
        }
        
        
    }
    
}
