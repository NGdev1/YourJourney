//
//  String.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

extension String {
    func percentEscapeString() -> String {
        let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                             self as CFString!,
                                                             nil,
                                                             ":/?@!$&'()*+,;=" as CFString!,
                                                             CFStringBuiltInEncodings.UTF8.rawValue)
        return (result as! String)
    }
    
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
    
    static func changeEndOfline(line : String, str : String)-> String {
        let startIndex = line.startIndex
        let endIndex = line.index(line.endIndex, offsetBy: -(str.length + 1))
        
        let lineBegin = line[startIndex...endIndex]
        return lineBegin + str
    }
}
