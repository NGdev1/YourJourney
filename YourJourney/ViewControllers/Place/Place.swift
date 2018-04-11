//
//  Place.swift
//  YourJourney
//
//  Created by Apple on 06.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit

class Place: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var labelPlaceName: UILabel!
    @IBOutlet weak var labelPlaceLication: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var constraintDescriptionHeigth: NSLayoutConstraint!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var imagesHeigth: NSLayoutConstraint!
    @IBOutlet weak var pageControlImages: UIPageControl!
    @IBOutlet weak var buttonShowOnMap: UIButton!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var buttonLikes: UIButton!
    @IBOutlet weak var buttonComments: UIButton!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        constraintDescriptionHeigth.constant = textViewDescription.contentSize.height
        
        imagesHeigth.constant = view.frame.width
        collectionViewImages.delegate = self
        
        buttonShowOnMap.applyYellowButtonDesign()
    }
    
    @IBAction func showOnMapAction(_ sender: Any) {
    }
}
