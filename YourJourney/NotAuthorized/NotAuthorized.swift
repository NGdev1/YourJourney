//
//  NotAuthorized.swift
//  YourJourney
//
//  Created by Apple on 06.11.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit

class NotAuthorized: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            //menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchDown)
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let nextVc = storyboard.instantiateInitialViewController()
        
        self.navigationController?.pushViewController(nextVc!, animated: true)
    }
}
