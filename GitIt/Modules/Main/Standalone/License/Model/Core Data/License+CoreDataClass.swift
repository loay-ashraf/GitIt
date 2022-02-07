//
//  License+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 25/01/2022.
//
//

import Foundation
import CoreData

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
