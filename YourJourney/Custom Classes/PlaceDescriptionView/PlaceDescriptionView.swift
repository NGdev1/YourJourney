//
//  PlaceDescription.swift
//  YourJourney
//
//  Created by Apple on 29.11.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit

class PlaceDescriptionView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var buttonPlaceName: UIButton!
    
    @IBOutlet weak var buttonShowAuthor: UIButton!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var buttonComments: UIButton!
    @IBOutlet weak var labelComments: UILabel!
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var constraintImageVIewHeight: NSLayoutConstraint!
    
    var imageViewHeight: CGFloat!
    
    var place: Place?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("PlaceDescriptionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func hideImageView() {
        constraintImageVIewHeight.constant = 0
    }
    
    func showImageView() {
        constraintImageVIewHeight.constant = imageViewHeight
    }
    
    func setAppearance(with place: Place) -> CGFloat {
        self.place = place
        
        var height : CGFloat = 197
        self.buttonPlaceName.setTitle(place.title, for: .normal)
        if place.logo != nil {
            self.showImageView()
            self.imageViewLogo.sd_setImage(with: URL(string: place.logo!))
        } else {
            height = 131
            self.hideImageView()
        }
        self.labelLikes.text = String(place.likes!)
        self.labelComments.text = String(place.comments!)
        
        self.loadAuthor(with: place.ownerId!)
        
        return height
    }
    
    func loadAuthor(with ownerId: Int) {
        labelUserName.text = "Автор"
        imageViewProfile.image = #imageLiteral(resourceName: "NoProfilePicture")
        
        TouristService.loadTourist(id: ownerId, places: false) {
            result in
            
            if result.error != nil {
                self.labelUserName.text = "?"
                return
            }
            
            guard result.tourist != nil else {
                return
            }
            
            if let avatar = result.tourist!.avatar {
                self.imageViewProfile.sd_setImage(with: URL(string: avatar))
            } else {
                self.imageViewProfile.image = #imageLiteral(resourceName: "NoProfilePicture")
            }
            
            self.labelUserName.text = result.tourist!.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Adds a shadow to our view
        layer.cornerRadius = 4.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 9.0
        layer.shadowOffset = CGSize.init(width: 0.0, height: -2.0)
        
        imageViewProfile.layer.cornerRadius = imageViewProfile.frame.width / 2.0
        imageViewProfile.clipsToBounds = true
        
        visualEffectView.layer.cornerRadius = 4.0
        
        imageViewHeight = constraintImageVIewHeight.constant
    }
}
