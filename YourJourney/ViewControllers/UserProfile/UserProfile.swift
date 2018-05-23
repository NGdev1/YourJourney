//
//  UserProfile.swift
//  YourJourney
//
//  Created by Apple on 13.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit

class UserProfile: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            //menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchDown)
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            //self.mapView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }
    
    func loadProfile() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
