//
//  FoundationExtensions.swift
//  GitIt
//
//  Created by Loay Ashraf on 11/01/2022.
//

import Foundation

extension Double {
    
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
}

extension String {
    
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
    
    func appendPathComponent<T: StringProtocol>(_ component: T) -> String {
        return appending("/").appending(component)
    }
    
    func appendQueryComponent<T: StringProtocol>(_ component: T) -> String {
        return appending("+").appending(component)
    }
    
}

extension Dictionary where Key: StringProtocol, Value: StringProtocol {
    
    var queryString: String {
        return map { $0.key + ":" + $0.value }.joined(separator: "+")
    }
    
}

extension Date {
    
    static func dateBefore(numberOfDays: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_us")
        let previousDate = Calendar.current.date(byAdding: .day, value: -numberOfDays, to: Self())!
        return dateFormatter.string(from: previousDate)
    }
    
}
