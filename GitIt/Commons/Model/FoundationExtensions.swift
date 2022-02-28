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

extension String: Model {
   
    typealias CollectionCellViewModelType = UserCollectionCellViewModel
    typealias TableCellViewModelType = UserTableCellViewModel
    
    var id: Int { return 0 }
    var htmlURL: URL { return URL(string: "www.github.com")! }
    var isComplete: Bool {
        get { return true }
        set {  }
    }
    
    init(from collectionCellViewModel: UserCollectionCellViewModel) {
        self.init()
    }
    
    init(from tableCellViewModel: UserTableCellViewModel) {
        self.init()
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

extension Mirror {
    
    func childValue(forLabel label: String) -> Any? {
        for child in children {
            if child.label == label {
                return child.value
            }
        }
        return nil
    }
    
}

extension Array {
    
    mutating func trim(toSize size: Int) {
        removeSubrange(size...count-1)
    }
    
    mutating func append<S: Sequence>(contentsOf newElements: S, withSizeLimit sizeLimit: Int) where Element == S.Element {
        if count >= sizeLimit {
            return
        } else {
            for newElement in newElements {
                append(newElement)
                if count == sizeLimit { break }
            }
        }
    }
    
}
