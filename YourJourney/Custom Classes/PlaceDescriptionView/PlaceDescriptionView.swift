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
    @IBOutlet weak var labelPlaceLocation: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var labelLikes: UILabel!
    @IBOutlet weak var buttonComments: UIButton!
    @IBOutlet weak var labelComments: UILabel!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// Adds a shadow to our view
        layer.cornerRadius = 4.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 9.0
        layer.shadowOffset = CGSize.init(width: 0.0, height: -2.0)
        
        visualEffectView.layer.cornerRadius = 4.0
    }
}
