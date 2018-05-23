//
//  Place.swift
//  YourJourney
//
//  Created by Apple on 06.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {
    
    var place: Place!
    
    @IBOutlet weak var labelPlaceName: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var constraintCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintDescriptionHeigth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var buttonShowOnMap: UIButton!
    
    @IBOutlet weak var buttonShowTouristProfile: UIButton!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var buttonLikes: UIButton!
    @IBOutlet weak var buttonComments: UIButton!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonShowOnMap.applyYellowButtonDesign()
        
        buttonShowTouristProfile.addTarget(self,
                                           action: #selector(showTouristProfile),
                                           for: .touchUpInside)
        
        imageViewProfile.layer.cornerRadius = imageViewProfile.frame.width / 2.0
        imageViewProfile.clipsToBounds = true
        
        collectionViewImages.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionViewImages.dataSource = self
        collectionViewImages.delegate = self
        
        guard place != nil else {
            return
        }
        
        labelPlaceName.text = place.title
        
        constraintDescriptionHeigth.constant = 0
        constraintCollectionViewHeight.constant = 0
        
        loadPlace(with: place.id!)
    }
    
    func loadPlace(with id: Int){
        self.view.startShowingActivityIndicator()
        
        PlaceService.loadPlace(id: id) {
            result in
            
            self.view.stopShowingActivityIndicator()
            
            if result.error != nil {
                self.showError(result.error!.localizedDescription)
                return
            }
            
            guard result.place != nil else {
                return
            }
            
            self.place = result.place
            self.setAppearance(with: self.place)
            
            self.loadTourist(with: self.place!.ownerId!)
        }
    }
    
    func loadTourist(with ownerId: Int) {
        labelProfileName.text = "Автор"
        imageViewProfile.image = #imageLiteral(resourceName: "NoProfilePicture")
        
        TouristService.loadTourist(id: ownerId, places: false) {
            result in
            
            if result.error != nil {
                return
            }
            
            guard result.tourist != nil else {
                return
            }
            
            self.setAppearanceAuthor(with: result.tourist!)
        }
    }
    
    func setAppearance(with place: Place) {
        self.labelPlaceName.text = place.title
        self.labelLikes.text = String(place.likes!)
        self.labelComments.text = String(place.comments!)
        self.textViewDescription.text = place.about
        
        self.constraintDescriptionHeigth.constant = self.textViewDescription.text.height(withConstrainedWidth: textViewDescription.contentSize.width - 20, font: textViewDescription.font!) + 20
        
        constraintCollectionViewHeight.constant = 0
        if place.photos != nil {
            if place.photos!.count > 0 {
                constraintCollectionViewHeight.constant = view.frame.width
                collectionViewImages.reloadData()
            }
        }
        
    }
    
    @objc func showTouristProfile() {
        let storyboard = UIStoryboard(name: "TouristProfile", bundle: nil)
        let nextVc = storyboard.instantiateInitialViewController() as! TouristProfile
        let tourist = Tourist()
        tourist.id = place.ownerId
        nextVc.tourist = tourist
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func setAppearanceAuthor(with tourist: Tourist) {
        self.labelProfileName.text = tourist.name
        
        if let avatar = tourist.avatar {
            let url = URL(string: avatar)
            self.imageViewProfile.sd_setImage(with: url)
        }  else {
            self.imageViewProfile.image = #imageLiteral(resourceName: "NoProfilePicture")
        }
    }
    
    @IBAction func showOnMapAction(_ sender: Any) {
    }
}
