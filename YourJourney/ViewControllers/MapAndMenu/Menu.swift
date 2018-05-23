//
//  Menu.swift
//  YourJourney
//
//  Created by Apple on 06.11.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit

class Menu: UITableViewController {
    
    var authorized = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        //DataManager.removeValue(key: "token")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        
        authorized = DataManager.getValue(key: "token") != nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !authorized {
            if indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4 {
                let storyboard = UIStoryboard(name: "NotAuthorized", bundle: nil)
                let nextVc = storyboard.instantiateInitialViewController()
                
                self.revealViewController().pushFrontViewController(nextVc, animated: true)
            }
        } else {
            if indexPath.row == 1 {
                let storyboard = UIStoryboard(name: "UserProfile", bundle: nil)
                let nextVc = storyboard.instantiateInitialViewController()
                
                self.revealViewController().pushFrontViewController(nextVc, animated: true)
            }
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
