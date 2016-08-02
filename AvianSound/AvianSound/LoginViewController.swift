//
//  ViewController.swift
//  AvianSound
//
//  Created by Ledesma Usop Jr. on 8/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import MBProgressHUD


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLoginButtonClick(sender: UIButton) {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        AvianSoundClient.sharedClient.login({ () -> () in
            
            print("logged in")
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.performSegueWithIdentifier("loginSegue", sender: self)
            
        }) { (error: NSError) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            print("error: \(error.localizedDescription)")
        }
               
    }
}

