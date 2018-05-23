//
//  TimeInterval.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

extension TimeInterval {
    func getStringDescription() -> String {

        let timeDifference = Date().timeIntervalSince1970 - self
        
        if timeDifference < 48 * 3600 {
            
            let days = (timeDifference / (3600 * 24))
            
            if days == 1 { return "вчера" }
            
            let hours = Int(timeDifference / 3600) % 24
            
            if hours == 0 {
                let minutes = timeDifference / 60
                return String(format: "%d минут назад", minutes)
            }
            if hours == 1 { return "час назад" }
            if hours == 2 { return "2 часа назад" }
            if hours == 3 { return "3 часа назад" }
            if hours == 4 { return "4 часа назад" }
            
            return String(format: "%d часов назад", hours)
            
        } else {
            
            let date = Date(timeIntervalSince1970: self)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "Ru")
            dateFormatter.dateFormat = "d MMMM"
            
            return dateFormatter.string(from: date)
        }
        
    }
}
