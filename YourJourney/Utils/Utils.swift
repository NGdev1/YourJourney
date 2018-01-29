//
//  Utils.swift
//  MyVkNews
//
//  Created by Apple on 22.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    var length: Int {
        return self.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[Range(start ..< end)])
    }
    
}

class Utils {
//    static func percentEscapeString(_ str: String) -> String {
//        return str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
////        return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
////                                                       str as CFString!,
////                                                       nil,
////                                                       ":/?@!$&'()*+,;=" as CFString!,
////                                                       CFStringBuiltInEncodings.UTF8.rawValue) as String;
//    }
    
    static func changeEndOfline(line : String, str : String)-> String {
        let startIndex = line.startIndex
        let endIndex = line.index(line.endIndex, offsetBy: -(str.length + 1))
        
        let lineBegin = line[startIndex...endIndex]
        return lineBegin + str
    }
    
    static func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        
        let days = (interval / (3600 * 24))
        
        if days == 1 { return "вчера" }
        
        let hours = (interval / 3600) % 24
        
        if hours == 0 {
            let minutes = interval / 60
            return String(format: "%d минут назад", minutes)
        }
        if hours == 1 { return "час назад" }
        if hours == 2 { return "2 часа назад" }
        if hours == 3 { return "3 часа назад" }
        if hours == 4 { return "4 часа назад" }
        
        return String(format: "%d часов назад", hours)
    }
    
    static func scaleImage(image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let prop = maximumWidth / image.size.width
        
        let rect = CGSize(width: maximumWidth, height: image.size.height * prop)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(rect, false, 1.0)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: rect))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    static func showError(_ message : String, viewController : UIViewController) {
        let alertController = UIAlertController(title: "", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Назад", style: UIAlertActionStyle.default,handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func askUser(_ question: String, viewController: UIViewController, actionNo: @escaping (UIAlertAction) -> Void, actionYes: @escaping (UIAlertAction) -> Void){
        let alertController = UIAlertController(title: question, message:
            "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.default, handler: actionNo))
        alertController.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: actionYes))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
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
