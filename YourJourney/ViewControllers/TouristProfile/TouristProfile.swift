//
//  TouristProfile.swift
//  YourJourney
//
//  Created by Apple on 23.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit

class TouristProfile: UIViewController {
    
    var tourist: Tourist!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    
    @IBOutlet weak var labelPlacesCount: UILabel!
    @IBOutlet weak var labelSubscribersCount: UILabel!
    @IBOutlet weak var labelSubscriptionsCount: UILabel!
    
    @IBOutlet weak var labelAbout: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = imageView.frame.width / 2.0
        imageView.clipsToBounds = true
        
        loadTourist(touristId: tourist.id!)
    }
    
    func loadTourist(touristId: Int) {
        self.view.startShowingActivityIndicator()
        
        TouristService.loadTourist(id: touristId, places: true) {
            result in
            
            self.view.stopShowingActivityIndicator()
            
            if result.error != nil {
                self.showError(result.error!.localizedDescription)
                return
            }
            
            guard result.tourist != nil else {
                return
            }
            
            self.tourist = result.tourist
            
            self.setAppearance(with: self.tourist)
        }
    }
    
    func setAppearance(with tourist: Tourist) {
        
        if let avatar = tourist.avatar {
            let url = URL(string: avatar)
            imageView.sd_setImage(with: url)
        }
        
        self.labelName.text = tourist.name
        self.labelCity.text = "\(tourist.homeCountry ?? ""), \(tourist.homeCity ?? "")"
        
        if let places = tourist.places {
            self.labelPlacesCount.text = String(places.count)
        }
        
        if let subscribers = tourist.subscribers {
            self.labelSubscribersCount.text = String(subscribers.count)
        }
        
        if let subscriptions = tourist.subscriptions {
            self.labelSubscriptionsCount.text = String(subscriptions.count)
        }
        
        labelAbout.text = tourist.about
    }
}
