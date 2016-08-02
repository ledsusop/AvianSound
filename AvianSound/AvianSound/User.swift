//
//  User.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        if let profileUrlString = dictionary["name"] as? String{
            profileUrl = NSURL(string: profileUrlString)
        }
    }
    
}
