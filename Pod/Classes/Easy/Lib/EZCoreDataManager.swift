//
//  EZCoreDataManager.swift
//  medical
//
//  Created by zhuchao on 15/5/31.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import CoreData

private var managedObjectContextHandle:UInt8 = 0
private var persistentStoreCoordinatorHandle:UInt8 = 1
private var databaseNameHandle:UInt8 = 2
private var modelNameHandle:UInt8 = 3
private var managedObjectModelHandle:UInt8 = 4

public class EZCoreDataManager {
    
    private static let appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
    
    public var databaseName: String {
        get {
            if let db = objc_getAssociatedObject(self, &databaseNameHandle) as? String {
                return db
            } else {
                return EZCoreDataManager.appName + ".sqlite"
            }
        }
        set(value){
            objc_setAssociatedObject(self, &databaseNameHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &managedObjectContextHandle, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &persistentStoreCoordinatorHandle, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var modelName: String {
        get {
            if let model = objc_getAssociatedObject(self, &modelNameHandle) as? String {
                return model
            } else {
                return EZCoreDataManager.appName
            }
        }
        set(value) {
            objc_setAssociatedObject(self, &modelNameHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &managedObjectContextHandle, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &persistentStoreCoordinatorHandle, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var managedObjectContext: NSManagedObjectContext {
        get {
            if let context = objc_getAssociatedObject(self, &managedObjectContextHandle) as? NSManagedObjectContext  {
                return context
            } else {
                let c = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
                c.persistentStoreCoordinator = persistentStoreCoordinator
                objc_setAssociatedObject(self, &managedObjectContextHandle, c, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return c
            }
        }
        set (value){
            objc_setAssociatedObject(self, &managedObjectContextHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        get {
            if let store = objc_getAssociatedObject(self, &persistentStoreCoordinatorHandle) as? NSPersistentStoreCoordinator  {
                return store
            } else {
                let p = self.persistentStoreCoordinator(NSSQLiteStoreType, storeURL: self.sqliteStoreURL)
                objc_setAssociatedObject(self, &persistentStoreCoordinatorHandle, p, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return p
            }
        }set(value){
            objc_setAssociatedObject(self, &persistentStoreCoordinatorHandle, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var managedObjectModel: NSManagedObjectModel {
        if let m = objc_getAssociatedObject(self, &managedObjectModelHandle) as? NSManagedObjectModel {
            return m
        } else {
            let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")
            let model = NSManagedObjectModel(contentsOfURL: modelURL!)
            objc_setAssociatedObject(self, &managedObjectModelHandle, model, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return model!
        }
    }
    
    public func useInMemoryStore() {
        persistentStoreCoordinator = self.persistentStoreCoordinator(NSInMemoryStoreType, storeURL: nil)
    }
    
    public func saveContext() -> Bool {
        return self.managedObjectContext.saveData()
    }
    
    private var sqliteStoreURL: NSURL {
        #if os(iOS)
            let dir = EZCoreDataManager.applicationDocumentsDirectory
            #else
            let dir = EZCoreDataManager.applicationSupportDirectory
            self.createApplicationSupportDirIfNeeded(dir)
        #endif
        return dir!.URLByAppendingPathComponent(self.databaseName)
        
    }
    
    private func persistentStoreCoordinator(storeType: String, storeURL: NSURL?) -> NSPersistentStoreCoordinator {
        let c = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let error = NSErrorPointer()
        do {
            try c.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true])
        } catch let error1 as NSError {
            error.memory = error1
            print("ERROR WHILE CREATING PERSISTENT STORE COORDINATOR! " + error.debugDescription)
        }
        return c
    }
    
    private static var applicationDocumentsDirectory:NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
    }
    
    private static var applicationSupportDirectory:NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last?.URLByAppendingPathComponent(EZCoreDataManager.appName)
    }
    
    private static func createApplicationSupportDirIfNeeded(dir: NSURL) {
        if NSFileManager.defaultManager().fileExistsAtPath(dir.absoluteString) {
            return
        }
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(dir, withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
    }
    // singleton
    public static let sharedManager = EZCoreDataManager()
}


public extension NSManagedObjectContext {
    
    public static var defaultContext: NSManagedObjectContext {
        return EZCoreDataManager.sharedManager.managedObjectContext
    }
    
    func createFetchRequest(entityName:String) -> NSFetchRequest {
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self)
        return request
    }
    
    func saveData() -> Bool {
        if !self.hasChanges {
            return true
        }
        let error = NSErrorPointer()
        let save: Bool
        do {
            try self.save()
            save = true
        } catch let error1 as NSError {
            error.memory = error1
            save = false
        }
        
        if (!save) {
            print("Unresolved error in saving context for entity:")
            print(self)
            print("!\nError: " + error.debugDescription)
            return false
        }
        return true
    }
}


public extension NSPredicate{
    
    public func condition(condition: AnyObject?) -> NSPredicate?{
        if let cond: AnyObject = condition {
            return NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates:[self, NSPredicate.predicate(cond)])
        }
        return self
    }
    
    public func orCondition(condition: AnyObject?) -> NSPredicate?{
        if let cond: AnyObject = condition {
            return NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates:[self, NSPredicate.predicate(cond)])
        }
        return self
    }
    
    private static func predicate(properties: [String:AnyObject]) -> NSPredicate {
        var preds = [NSPredicate]()
        for (key, value) in properties {
            preds.append(NSPredicate(format: "%K = %@", argumentArray: [key, value]))
        }
        return NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: preds)
    }
    
    private static func predicate(condition: AnyObject) -> NSPredicate {
        if condition is NSPredicate {
            return condition as! NSPredicate
        }
        if let d = condition as? [String:AnyObject] {
            return self.predicate(d)
        }
        return NSPredicate()
    }
}

public extension NSFetchRequest{
    
    public func condition(condition: AnyObject?) -> NSFetchRequest{
         if let cond: AnyObject = condition {
            if let pred = self.predicate {
                self.predicate = pred.condition(cond)
            }else{
                self.predicate = NSPredicate.predicate(cond)
            }
        }
        return self
    }
    
    public func orCondition(condition: AnyObject?) -> NSFetchRequest{
        if let cond: AnyObject = condition,let pred = self.predicate  {
            self.predicate = pred.orCondition(cond)
        }
        return self
    }
    
    public func orderBy(key:String,_ order:String = "ASC") -> NSFetchRequest{
        let sortDescriptor = NSSortDescriptor(key: key, ascending: order.uppercaseString=="ASC")
        if self.sortDescriptors == nil{
            self.sortDescriptors = [sortDescriptor]
        }else{
            self.sortDescriptors?.append(sortDescriptor)
        }
        return self
    }
    
    /**
    * Set the "limit" value of the query.
    *
    * @param int value
    * @return self
    * @static
    */
    public func limit(value:Int) -> NSFetchRequest{
        self.fetchLimit = value
        self.fetchOffset = 0
        return self
    }
    
    /**
    * Alias to set the "limit" value of the query.
    *
    * @param int value
    * @return NSFetchRequest
    */
    public func take(value:Int) -> NSFetchRequest{
        return self.limit(value)
    }
    
    /**
    * Set the limit and offset for a given page.
    *
    * @param int page
    * @param int perPage
    * @return NSFetchRequest
    */
    public func forPage(page:Int,_ perPage:Int) -> NSFetchRequest{
        self.fetchLimit = perPage
        self.fetchOffset = (page - 1) * perPage
        return self
    }
    
    public func first() -> NSManagedObject?{
        return self.take(1).get().first
    }
    
    public func delete() -> NSInteger{
        var i = 0
        for o in self.get() {
            o.delete()
            i++
        }
        return i
    }
    
    public func get() -> [NSManagedObject]{
        return (try! NSManagedObjectContext.defaultContext.executeFetchRequest(self)) as! [NSManagedObject] 
    }
    
    public func count() -> Int {
        return NSManagedObjectContext.defaultContext.countForFetchRequest(self, error: nil)
    }
    
    public func exists() -> Bool {
        return self.count() > 0
    }
    
}


