//
//  GoodsCoreDataModel.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 10/08/22.
//

import Foundation
import CoreData
@objc(CarCoreData)
class CarCoreData: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var descriptionn: String?
    @NSManaged var photoPath: String?
    @NSManaged var purchasePrice: NSNumber?
    @NSManaged var sellingPrice: NSNumber?
    @NSManaged var discount: NSNumber?
    @NSManaged var count: NSNumber?
    @NSManaged var liked: NSNumber?

}


