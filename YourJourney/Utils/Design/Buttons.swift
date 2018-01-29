//
//  Buttons.swift
//  YourJourney
//
//  Created by Apple on 13.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import Foundation

extension UIButton {
    func applyYellowButtonDesign() {
        self.layer.cornerRadius = self.bounds.height / 2
        self.setTitleColor(UIColor.black, for: .normal)
        self.backgroundColor = UIColor.sunflowerYellow
    }
}
