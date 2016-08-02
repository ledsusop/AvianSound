//
//  TweetsViewController.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets:[Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadHome()
    }
    
    @IBAction func onLogoutBtnClick(sender: UIBarButtonItem) {
        AvianSoundClient.sharedClient.logout()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetTableCell", forIndexPath: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func loadHome(){
        AvianSoundClient.sharedClient.homeTimeline({ (tweets: [Tweet]) -> () in
            
            self.tweets = tweets
            
            for tweet in self.tweets {
                print(tweet.text)
            }
            
            self.tableView.reloadData()
            
            }, failure:  { (error: NSError!) -> () in
                
                print("error: \(error.localizedDescription)")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
