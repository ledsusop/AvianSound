//
//  ComposeTweetViewController.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/2/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeTweetViewController: UIViewController, UITextFieldDelegate {
    
   var profileBtn: UIBarButtonItem!
    
    @IBOutlet weak var tweetBtn: UIButton!
    @IBOutlet weak var footerMenu: UIView!
    @IBOutlet weak var tweetInput: UITextField!
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    
    var firstViewController: TweetsViewController!
    
    internal func setUserProfile(imageView: UIImageView, nsURL: NSURL?){
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
                            imageView.alpha = 1
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
    
    @IBAction func onTweetButtonClick(sender: UIButton) {
        print("posting tweet now")
        AvianSoundClient.sharedClient.tweet(tweetInput.text!, success: { () -> () in
            self.dismissViewControllerAnimated(true) {
                print("tweeted: \(self.tweetInput.text)")
                self.firstViewController.loadData(nil)
            }
        }) {(error: NSError!) -> () in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func onProfileBtnClick(sender: UIView) {
        print("profile image clicked")
    }

    @IBAction func onStopComposeClick(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true) { 
            print("cancelled compose")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeTweetViewController.onKeyboardShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            #selector(ComposeTweetViewController.onKeyboardHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        setupNavButtons()
    }
    
    func onKeyboardShow(notification:NSNotification){
        
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.footerBottomConstraint.constant = keyboardFrame.size.height
        })
        
    }
    
    func onKeyboardHide(notification:NSNotification){
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.footerBottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    func setupNavButtons () {
        
        tweetInput.delegate = self
        
        if let currentUser = User.currentUser{
            let imageView = UIImageView(frame: CGRectMake(0, 0, 35, 35))
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(ComposeTweetViewController.onProfileBtnClick(_:)))
            singleTap.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(singleTap)
            imageView.userInteractionEnabled = true
            imageView.layer.cornerRadius = 5
            imageView.clipsToBounds = true
            profileBtn = UIBarButtonItem(customView: imageView)
            navigationItem.leftBarButtonItem = profileBtn
            self.setUserProfile(profileBtn.customView as! UIImageView, nsURL: currentUser.profileImageUrl)
            
        }else{
            profileBtn = UIBarButtonItem(title: "Profile", style: .Plain, target: self, action: #selector(ComposeTweetViewController.onProfileBtnClick(_:)))
            
            navigationItem.leftBarButtonItem = profileBtn
        }
        
        tweetBtn.layer.cornerRadius = 5
        tweetInput.becomeFirstResponder()

    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        let border = CALayer()
        border.backgroundColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: 0, width: footerMenu.frame.width, height: 0.5)
        footerMenu.layer.addSublayer(border)
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
