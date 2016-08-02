//
//  TweetTableViewCell.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    var tweet: Tweet! {
        didSet {
            self.populateFields()
        }
    }
    
    internal func populateFields() {
        if tweet != nil {
            userName.text = tweet.user?.name as? String
            userScreenName.text = "@"+((tweet.user?.screenName)! as String)
            tweetText.text = tweet.text as? String
            
            if let tweetDate = tweet.timeStamp {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "hh:mm a dd:MM:yy"
                timeStamp.text = formatter.stringFromDate(tweetDate)
            }
            
            self.setImageURL(userProfileImage, nsURL: tweet.user?.profileImageUrl)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfileImage.layer.cornerRadius = 5
        userProfileImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
