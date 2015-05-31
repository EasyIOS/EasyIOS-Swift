//
//  EZCoreDataManager.swift
//  medical
//
//  Created by zhuchao on 15/5/31.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import CoreData

public class EZCoreDataManager {
    
    public let appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
    
    public var databaseName: String {
        get {
            if let db = self._databaseName {
                return db
            } else {
                return self.appName + ".sqlite"
            }
        }
        set {
            _databaseName = newValue
            if _managedObjectContext != nil {
                _managedObjectContext = nil
            }
            if _persistentStoreCoordinator != nil {
                _persistentStoreCoordinator = nil
            }
        }
    }
    private var _databaseName: String?
    
    public var modelName: String {
        get {
            if let model = _modelName {
                return model
            } else {
                return appName
            }
        }
        set {
            _modelName = newValue
            if _managedObjectContext != nil {
                _managedObjectContext = nil
            }
            if _persistentStoreCoordinator != nil {
                _persistentStoreCoordinator = nil
            }
        }
    }
    private var _modelName: String?
    
    public var managedObjectContext: NSManagedObjectContext {
        get {
            if let context = _managedObjectContext {
                return context
            } else {
                let c = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
                c.persistentStoreCoordinator = persistentStoreCoordinator
                _managedObjectContext = c
                return c
            }
        }
        set {
            _managedObjectContext = newValue
        }
    }
    private var _managedObjectContext: NSManagedObjectContext?
    
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        if let store = _persistentStoreCoordinator {
            return store
        } else {
            let p = self.persistentStoreCoordinator(NSSQLiteStoreType, storeURL: self.sqliteStoreURL)
            _persistentStoreCoordinator = p
            return p
        }
    }
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    
    public var managedObjectModel: NSManagedObjectModel {
        if let m = _managedObjectModel {
            return m
        } else {
            let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")
            _managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL!)
            return _managedObjectModel!
        }
    }
    private var _managedObjectModel: NSManagedObjectModel?
    
    public func useInMemoryStore() {
        _persistentStoreCoordinator = self.persistentStoreCoordinator(NSInMemoryStoreType, storeURL: nil)
    }
    
    public func saveContext() -> Bool {
        return self.managedObjectContext.saveTheContext()
    }
    
    public func applicationDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as! NSURL
    }
    
    public func applicationSupportDirectory() -> NSURL {
        return (NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as! NSURL).URLByAppendingPathComponent(self.appName)
    }
    
    private var sqliteStoreURL: NSURL {
        #if os(iOS)
            let dir = self.applicationDocumentsDirectory()
            #else
            let dir = self.applicationSupportDirectory()
            self.createApplicationSupportDirIfNeeded(dir)
        #endif
        return dir.URLByAppendingPathComponent(self.databaseName)
        
    }
    
    private func persistentStoreCoordinator(storeType: String, storeURL: NSURL?) -> NSPersistentStoreCoordinator {
        let c = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let error = NSErrorPointer()
        if c.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: [NSMigratePersistentStoresAutomaticallyOption:true,NSInferMappingModelAutomaticallyOption:true], error: error) == nil {
            println("ERROR WHILE CREATING PERSISTENT STORE COORDINATOR! " + error.debugDescription)
        }
        return c
    }
    
    private func createApplicationSupportDirIfNeeded(dir: NSURL) {
        if NSFileManager.defaultManager().fileExistsAtPath(dir.absoluteString!) {
            return
        }
        NSFileManager.defaultManager().createDirectoryAtURL(dir, withIntermediateDirectories: true, attributes: nil, error: nil)
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
    
    func saveTheContext() -> Bool {
        if !self.hasChanges {
            return true
        }
        let error = NSErrorPointer()
        let save = self.save(error)
        
        if (!save) {
            println("Unresolved error in saving context for entity:")
            println(self)
            println("!\nError: " + error.debugDescription)
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
    
    public func get() -> [NSManagedObject]{
        return NSManagedObjectContext.defaultContext.executeFetchRequest(self, error: nil) as! [NSManagedObject] 
    }
    
    public func count() -> Int {
        return NSManagedObjectContext.defaultContext.countForFetchRequest(self, error: nil)
    }
    
    public func exists() -> Bool {
        return self.count() > 0
    }
    
}



