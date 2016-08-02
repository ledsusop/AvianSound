//
//  TweetDetailsViewController.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/2/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    var tweet:Tweet!
    
    internal func populateFields() {
        
        if userName != nil {
            if tweet != nil {
                userName.text = tweet.user?.name as? String
                screenName.text = "@"+((tweet.user?.screenName)! as String)
                tweetText.text = tweet.text as? String
                
                if let tweetDate = tweet.timeStamp {
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "hh:mm a dd:MM:yy"
                    timeStamp.text = formatter.stringFromDate(tweetDate)
                }
                
                self.setImageURL(profileImageView, nsURL: tweet.user?.profileImageUrl)
            }

        }
    }
    
    internal func setImageURL(imageView:UIImageView, nsURL: NSURL?){
        if nsURL != nil {
            let imageRequest = NSURLRequest(URL: nsURL!)
            imageView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        imageView.alpha = 0.0
                        imageView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            imageView.alpha = 1.0
                        })
                    } else {
                        imageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
    }

    
    var firstViewController:TweetsViewController!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var footerMenu: UIView!
    @IBOutlet weak var timeStamp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        self.populateFields()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReplyTweet(sender: UIButton) {
    }

    @IBAction func onFavoriteTweet(sender: UIButton) {
    }
    
    @IBAction func onRetweet(sender: UIButton) {
    
    }
    
    @IBAction func onBackButtonClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) {
            print("close details")
        }
    }
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        let border = CALayer()
        border.backgroundColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: 0, width: footerMenu.frame.width, height: 0.5)
        footerMenu.layer.addSublayer(border)
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
