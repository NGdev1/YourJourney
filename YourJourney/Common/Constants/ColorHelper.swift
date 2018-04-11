//
//  Colors.swift
//  YourJourney
//
//  Created by Apple on 13.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import Foundation

import UIKit

class ColorHelper {
    
    enum ColorName {
        case sunflowerYellow
    }
    
    static func color(for name: ColorName) -> UIColor {
        switch name {
        case .sunflowerYellow:
            return #colorLiteral(red: 1, green: 0.8352941176, blue: 0.007843137255, alpha: 1)
        }
    }
}
