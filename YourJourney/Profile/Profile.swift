//
//  Profile.swift
//  YourJourney
//
//  Created by Apple on 13.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit

class Profile: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            //menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchDown)
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            //self.mapView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        label.text = DataManager.getValue(key: "token") as? String
    }
}
