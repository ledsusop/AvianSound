//
//  AvianSoundClient.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//
import UIKit
import BDBOAuth1Manager

class AvianSoundClient:BDBOAuth1SessionManager {
    
    static let twitterAPIVersion = "1.1"
    static let baseURLString = "https://api.twitter.com"
    static let baseURL = NSURL(string:AvianSoundClient.baseURLString)
    static let consumerKey = "GMMoxjUFFdLddpjN5nxq391R9"
    static let consumerSecret = "xmnUBHB7ejgOwabetx0T1swNYW9oOsj2gCH8Rfvj5zdxnHRrC9"
    static let requestTokenPath = "oauth/request_token"
    static let accessTokenPath = "oauth/access_token"
    static let appCallbackURL = "aviansoundapp://oauth"
    static let authorizeURL = "https://api.twitter.com/oauth/authorize?oauth_token"
    static let verifyCredentialPath = AvianSoundClient.twitterAPIVersion+"/account/verify_credentials.json"
    static let homeTimeLinePath = AvianSoundClient.twitterAPIVersion+"/statuses/home_timeline.json"
    static let tweetPath = AvianSoundClient.twitterAPIVersion+"/statuses/update.json"
    static let favoritesPath = AvianSoundClient.twitterAPIVersion+"/favorites/create.json"
    static let reTweetBasePath = AvianSoundClient.twitterAPIVersion+"/statuses/retweet/"
    
    
    
    static let GET = "GET"
    static let POST = "POST"
    static let PUT = "PUT"
    
    static let sharedClient = AvianSoundClient(baseURL: NSURL(string: AvianSoundClient.baseURLString)!, consumerKey: AvianSoundClient.consumerKey, consumerSecret: AvianSoundClient.consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func generateUthorizeURL(requestToken:BDBOAuth1Credential) -> NSURL {
        return NSURL(string:AvianSoundClient.authorizeURL+"=\(requestToken.token)")!
    }
    
    func fetchRequestToken(success: (BDBOAuth1Credential!) -> Void, failure: (error: NSError!) -> Void){
        fetchRequestTokenWithPath(AvianSoundClient.requestTokenPath, method: AvianSoundClient.GET, callbackURL: NSURL(string:AvianSoundClient.appCallbackURL), scope: nil, success: success, failure: failure)
    }
    
    func fetchAccessToken(requestToken: BDBOAuth1Credential, success: (BDBOAuth1Credential!) -> Void, failure: (error: NSError!) -> Void){
        fetchAccessTokenWithPath(AvianSoundClient.accessTokenPath, method: AvianSoundClient.POST, requestToken: requestToken, success: success, failure: failure)
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        
        GET(AvianSoundClient.verifyCredentialPath, parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            print(response)
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            print("user: \(user.name)")
            success(user)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                
                print("error: \(error.localizedDescription)")
                failure(error)
                
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET(AvianSoundClient.homeTimeLinePath, parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            print(response)
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                
                print("error: \(error.localizedDescription)")
                failure(error)
                
        })
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        self.deauthorize()
        
        self.fetchRequestToken({(requestToken:BDBOAuth1Credential!) -> Void in
            
                let url = self.generateUthorizeURL(requestToken)
                UIApplication.sharedApplication().openURL(url)
            
            }, failure: { (error: NSError!) -> Void in
                
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
                
        })
        
    }
    
    func logout() {
        User.currentUser = nil
        self.deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
    }
    
    func handleURLCallback(url:NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        self.fetchAccessToken(requestToken, success: { (fetchAccessToken:BDBOAuth1Credential!) -> Void in
            
            print("access token received")
            
            
            self.currentAccount({ (user: User) -> () in
                
                User.currentUser = user
                
                self.loginSuccess?()
                
                }, failure:  { (error: NSError!) -> () in
                    print("error: \(error.localizedDescription)")
                    self.loginFailure?(error)
            })
            
            

            
            
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
        
    }
    
    func tweet(tweetMessage : String, tweetToReplyToId: Int?, success: () -> (), failure: (NSError) -> ()){
        
        POST(AvianSoundClient.tweetPath, parameters: tweetToReplyToId != nil ? ["status":tweetMessage,"in_reply_to_status_id":String(tweetToReplyToId)]: ["status":tweetMessage], progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            print(response)
            
            //let dictionaries = response as! [NSDictionary]
            //let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success()
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                
                print("error: \(error.localizedDescription)")
                failure(error)
                
        })
    }
    
    func reTweet(tweet: Tweet, success: () -> (), failure: (NSError) -> ()){
        
        POST(AvianSoundClient.reTweetBasePath+String(tweet.id)+".json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            print(response)
            
            
            success()
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                
                print("error: \(error.localizedDescription)")
                failure(error)
                
        })
    }
    
    func favorite(tweet: Tweet, success: () -> (), failure: (NSError) -> ()){
        
        POST(AvianSoundClient.favoritesPath, parameters: ["id":tweet.id], progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
            print(response)
            
            
            success()
            
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                
                print("error: \(error.localizedDescription)")
                failure(error)
                
        })
    }
    
    
}
