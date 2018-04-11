//
//  MapPin.swift
//  YourJourney
//
//  Created by Apple on 11.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class MapPin {
    static func drawMapPin(_ likes: String) -> UIImage {
        let mapPinImg = #imageLiteral(resourceName: "MapPin")
        
        var rect = CGSize(width: 23, height: 42)
        
        if likes.length > 2 {
            rect = CGSize(width: 33, height: 56)
        }
        
        UIGraphicsBeginImageContextWithOptions(rect, false, 2.0)
        mapPinImg.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: rect))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attrs = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.paragraphStyle: paragraphStyle
            ] as [NSAttributedStringKey : Any]
        
        (likes as NSString).draw(in: CGRect(origin: CGPoint(x: 0, y: rect.height / 8.5),
                                            size: CGSize(width: rect.width, height: 23)),
                                 withAttributes: attrs)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
