//
//  CoreDataSyncManager.swift
//  Oq ot
//
//  Created by Sirojiddinov Mirjalol on 10/08/22.
//


import UIKit
import CoreData
class CoreDataSyncManager {
    static let shared = CoreDataSyncManager()
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cadiridris.coreDataTemplate" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
        // This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CarCoreDataModel.sqlite")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try? coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        }
        return coordinator
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CarCoreDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    func saveToCoreData(model: EachDiscountedGood) {
        if getGoodsCountBy(by: model.id) == false {
            let context: NSManagedObjectContext = managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "CarCoreData", in: context)
            let car = CarCoreData(entity: entity!, insertInto: context)
            car.id = model.id
            car.name = model.name
            car.descriptionn = model.description
            car.photoPath = model.photoPath
            car.sellingPrice = NSNumber(value: model.sellingPrice)
            car.purchasePrice = NSNumber(value: model.purchasePrice)
            car.discount = NSNumber(value: model.discount)
            car.count = 1
            do {
                try context.save()
            } catch {
                
            }
        } else {
            updateGoodCount(by: model.id)
        }
    }
    
    
    func saveToCoreDataOrUpdateCount(model: EachDiscountedGood, count: Int) {
        if getGoodsCountBy(by: model.id) == false {
            let context: NSManagedObjectContext = managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "CarCoreData", in: context)
            let car = CarCoreData(entity: entity!, insertInto: context)
            car.id = model.id
            car.name = model.name
            car.descriptionn = model.description
            car.photoPath = model.photoPath
            car.sellingPrice = NSNumber(value: model.sellingPrice)
            car.purchasePrice = NSNumber(value: model.purchasePrice)
            car.discount = NSNumber(value: model.discount)
            car.count = 1
            do {
                try context.save()
            } catch {
                
            }
        } else {
            updateGoodCountWithCount(by: model.id, count: count)
        }
    }
    
    func saveAddressToCoreData(model: EachAddress) {
        if getAddressBy(by: model.id) == false {
            let context: NSManagedObjectContext = managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "AddressCoreData", in: context)
            let address = AddressCoreData(entity: entity!, insertInto: context)
            address.id = model.id
            address.clientId = model.clientId
            address.address = model.address
            address.createdAt = model.createdAt
            address.latitude = NSNumber(value: model.latitude)
            address.longitude = NSNumber(value: model.longitude)
            do {
                try context.save()
            } catch {
                
            } 
        } else {
            updateAddress(by: model.id, address: model.address)
        }
    }
    
    func fetchAdresses() -> [EachAddress] {
       let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressCoreData")
       do {
           let results = try context.fetch(request) as! [AddressCoreData]
           var tempModelArray: [EachAddress] = []
           for i in results {
               let mod = EachAddress(address: i.address ?? "", longitude: Double(i.longitude ?? 0.0), clientId: i.clientId ?? "", createdAt: i.createdAt ?? "", latitude: Double(i.latitude ?? 0.0), id: i.id ?? "")
                   tempModelArray.append(mod)
           }
           return tempModelArray
       } catch  {
           print("error occured")
       }
       return []
    }
    
    func getAddressBy(by id: String?) -> Bool {
        guard let id = id else {return false}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressCoreData")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id)
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        do {
            let count = try context.count(for: request)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func updateAddress(by id: String?, address: String) {
        guard let id = id else { return }
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressCoreData")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@",id)
        do {
            let result = try context.fetch(request) as! [AddressCoreData]
            if result.count == 1 {
                result[0].address = address
                try? context.save()
            }
        } catch {
            print("error occured")
        }
    }
    
    func deleteAddress(by id: String?) {
        guard let id = id else { return }
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressCoreData")
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %@",id)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch  {
            print("error occured")
        }
    }
    
    func selectAddress(by id: String?, shouldSelect: Bool) {
        guard let id = id else { return }
        deselectAllAdresses()
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressCoreData")
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %@",id)
        do {
            let results = try context.fetch(request) as! [AddressCoreData]
            if results.count == 1 {
                results[0].isSelected = shouldSelect ? 1 : 0
               try? context.save()
            }
        } catch  {
            print("error occured")
        }
    }
    
    func getSelectedAddress() -> EachAddress? {
       let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressCoreData")
       do {
           let results = try context.fetch(request) as! [AddressCoreData]
           for i in results {
               if i.isSelected == 1 {
                   let mod = EachAddress(address: i.address ?? "", longitude: Double(i.longitude ?? 0.0), clientId: i.clientId ?? "", createdAt: i.createdAt ?? "", latitude: Double(i.latitude ?? 0.0), id: i.id ?? "")
                       return mod
               }
           }
       } catch  {
           print("error occured")
       }
       return nil
    }
    
    func deselectAllAdresses() {
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AddressCoreData")
        request.fetchLimit =  1
        do {
            let results = try context.fetch(request) as! [AddressCoreData]
            results.forEach { $0.isSelected = 0}
            try? context.save()
            
        } catch  {
            print("error occured")
        }
    }
    
    // ---------------
    
    func fetchLikedGoods() -> [EachDiscountedGood] {
       let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
       do {
           let results = try context.fetch(request) as! [CarCoreData]
           var tempModelArray: [EachDiscountedGood] = []
           for i in results {
               if i.liked == 1 {
                   let mod = EachDiscountedGood(id: i.id ?? "", name: i.name ?? "", description: i.descriptionn ?? "", photoPath: i.photoPath ?? "", purchasePrice: i.purchasePrice?.intValue ?? 0, sellingPrice: i.sellingPrice?.intValue ?? 0, discount: i.discount?.doubleValue ?? 0.0, count: 1)
                   tempModelArray.append(mod)
               }
             
           }
           return tempModelArray
       } catch  {
           print("error occured")
       }
       return []
   }
    
    func fetchGoodsData() -> [EachDiscountedGoodForCoreData] {
       let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
       do {
           let results = try context.fetch(request) as! [CarCoreData]
           var tempModelArray: [EachDiscountedGoodForCoreData] = []
           for i in results {
               if i.count?.intValue ?? 0 > 0 {
                   let mod = EachDiscountedGoodForCoreData(id: i.id ?? "", name: i.name ?? "", description: i.descriptionn ?? "", photoPath: i.photoPath ?? "", purchasePrice: i.purchasePrice?.intValue ?? 0, sellingPrice: i.sellingPrice?.intValue ?? 0, discount: i.discount?.doubleValue ?? 0.0, liked: (i.liked == 1) , count: Int(truncating: i.count!) )
                   tempModelArray.append(mod)
               }
             
           }
           return tempModelArray
       } catch  {
           print("error occured")
       }
       return []
    }
    
    func getGoodsCountBy(by id: String?) -> Bool {
        guard let id = id else { return false }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@",id)
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        do {
            let count = try context.count(for: request)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func getItemCount(id: String?) -> Int{
        guard let id = id else { return 0}
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %@",id)
        do {
            let results = try context.fetch(request) as! [CarCoreData]
            if results.count == 1 {
                return results[0].count as! Int
            }
        } catch  {
            print("error occured")
        }
        return 0
    }
    
    
    func likeItem(by model: EachDiscountedGood?, shouldLike: Bool){
        guard let model = model else { return }
        
        if getGoodsCountBy(by: model.id) == false {
            let context: NSManagedObjectContext = managedObjectContext
            let entity = NSEntityDescription.entity(forEntityName: "CarCoreData", in: context)
            let car = CarCoreData(entity: entity!, insertInto: context)
            car.id = model.id
            car.name = model.name
            car.descriptionn = model.description
            car.photoPath = model.photoPath
            car.sellingPrice = NSNumber(value: model.sellingPrice)
            car.purchasePrice = NSNumber(value: model.purchasePrice)
            car.discount = NSNumber(value: model.discount)
            car.liked = shouldLike ? 1 : 0
            do {
                try context.save()
            } catch {
                
            }
        } else {
            let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
            request.fetchLimit =  1
            request.predicate = NSPredicate(format: "id == %@",model.id)
            do {
                let results = try context.fetch(request) as! [CarCoreData]
                if results.count == 1 {
                    results[0].liked = shouldLike ? 1 : 0
                   try? context.save()
                }
            } catch  {
                print("error occured")
            }
        }
    }
    
    func updateGoodCount(by id: String?, shouldAdd: Bool = true){
        guard let id = id else { return }
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %@",id)
        do {
            let results = try context.fetch(request) as! [CarCoreData]
            if results.count == 1 {
                results[0].count = shouldAdd ? NSNumber(value: results[0].count as! Int + 1) : NSNumber(value: results[0].count as! Int - 1)
                if shouldAdd == false {
                    if let count = results[0].count as? Int, let liked = results[0].liked, count < 1, liked == 0 {
                        deleteItem(by: id)
                    }
                }
               try? context.save()
              
            }
        } catch  {
            print("error occured")
        }
    }
    
    func updateGoodCountWithCount(by id: String?, count: Int){
        guard let id = id else { return }
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %@",id)
        do {
            let results = try context.fetch(request) as! [CarCoreData]
            if results.count == 1 {
                results[0].count = NSNumber(value: count)
               try? context.save()
              
            }
        } catch  {
            print("error occured")
        }
    }
    
    func deleteItem(by id: String?){
        guard let id = id else { return }
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %@",id)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch  {
            print("error occured")
        }
    }
    

    func isItemLiked(id: String?) -> Bool{
        guard let id = id else { return false}
        let context: NSManagedObjectContext = CoreDataSyncManager.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %@",id)
        do {
            let results = try context.fetch(request) as! [CarCoreData]
            if results.count == 1 {
                return results[0].liked == 1 ? true : false
            }
        } catch  {
            print("error occured")
        }
        return false
    }
    
    func deleteAllRecords() {
        //delete all data
        let context: NSManagedObjectContext = managedObjectContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
    func deleteBasketGoods() {
        let context: NSManagedObjectContext = managedObjectContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CarCoreData")
        do {
            
            let results = try context.fetch(deleteFetch) as! [CarCoreData]
               for item in results {
                   if item.count?.intValue ?? 0 > 0 {
                       context.delete(item)
                   }
               }
               try context.save()
        } catch {
            print ("There was an error")
        }
    }

    
}
