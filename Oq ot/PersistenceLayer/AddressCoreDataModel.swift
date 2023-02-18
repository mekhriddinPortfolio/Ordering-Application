//
//  AddressCoreDataModel.swift
//  Oq ot
//
//  Created by AvazbekOS on 22/08/22.
//

import Foundation
import CoreData
@objc(AddressCoreData)
class AddressCoreData: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var address: String?
    @NSManaged var clientId: String?
    @NSManaged var createdAt: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var isSelected: NSNumber?
}
