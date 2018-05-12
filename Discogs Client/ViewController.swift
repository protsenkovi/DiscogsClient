//
//  ViewController.swift
//  Discogs Client
//
//  Created by Leonid Petrov on 14/01/2018.
//  Copyright © 2018 Leonid Petrov. All rights reserved.
//

import UIKit
import OAuthSwift
import WebKit


class ViewController: UIViewController {

    let userDefaults = UserDefaults.standard

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let oauthswift = AuthorizeService.authorize(completionOnSuccess: {
            if AuthorizeService.isAuthorized {
                self.performSegue(withIdentifier: "toApp", sender: self)
            }
            self.userDefaults.set(AuthorizeService.token, forKey: "token")
            print("Success")
        })
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewDidAppear(_ animated: Bool) {
        AuthorizeService.token = userDefaults.string(forKey: "token") ?? ""
        
        if AuthorizeService.token != "" {
            self.performSegue(withIdentifier: "toApp", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

