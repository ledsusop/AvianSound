//
//  User.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let USER_DID_LOGOUT = "UserDidLogout"
    
    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    var profileImageUrl: NSURL?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        if let profileUrlString = dictionary["name"] as? String{
            profileUrl = NSURL(string: profileUrlString)
        }
        
        if let profileImageUrlString = dictionary["profile_image_url"] as? String{
            profileImageUrl = NSURL(string: profileImageUrlString)
        }
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData =  defaults.objectForKey("currentUserData") as? NSData
            
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
             return _currentUser
        }
        
        set (user) {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }else{
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
