//
//  License+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 25/01/2022.
//
//

import Foundation
import CoreData
import RealmSwift

@objc(License)
public class License: NSManagedObject {
    
    convenience init?(from licenseModel: LicenseModel?, in context: NSManagedObjectContext) {
        self.init(context: context)
        if let licenseModel = licenseModel {
            self.name = licenseModel.name
            self.key = licenseModel.key
            self.url = licenseModel.url
        } else {
            return nil
        }
    }

}

class LicenseBookmark: Object {
    
    @Persisted var key: String?
    @Persisted var name: String?
    @Persisted var url: String?
    
    convenience init?(from licenseModel: LicenseModel?) {
        self.init()
        if let licenseModel = licenseModel {
            self.name = licenseModel.name
            self.key = licenseModel.key
            self.url = licenseModel.url.absoluteString
        } else {
            return nil
        }
    }
    
}
