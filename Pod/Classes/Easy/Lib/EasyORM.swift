//
//  NSManagedObject+EZExtend.swift
//  medical
//
//  Created by zhuchao on 15/5/30.
//  Copyright (c) 2015年 zhuchao. All rights reserved.
//

import Foundation
import CoreData

public func DBQuery(aClass: NSManagedObject.Type!,entityName:String) -> NSFetchRequest {
    return aClass.defaultContext().createFetchRequest(entityName)
}

public class EasyORM {
    
    public static var generateRelationships = false
    
    public static func setUpEntities(entities: [String:NSManagedObject.Type]) {
        nameToEntities = entities
    }
    
    private static var nameToEntities: [String:NSManagedObject.Type] = [String:NSManagedObject.Type]()

    
}

public extension NSManagedObject{

    public func defaultContext() -> NSManagedObjectContext{
        return self.managedObjectContext ?? self.dynamicType.defaultContext()
    }
    
    public static func defaultContext() -> NSManagedObjectContext{
        return NSManagedObjectContext.defaultContext
    }
    
    private static var query:NSFetchRequest{
        return self.defaultContext().createFetchRequest(self.entityName())
    }
    
    public static func condition(condition: AnyObject?) -> NSFetchRequest{
        return self.query.condition(condition)
    }
    
    public static func orderBy(key:String,_ order:String = "ASC") -> NSFetchRequest{
        return self.query.orderBy(key, order)
    }
    
    /**
    * Set the "limit" value of the query.
    *
    * @param int value
    * @return self
    * @static
    */
    public static func limit(value:Int) -> NSFetchRequest{
        return self.query.limit(value)
    }
    
    /**
    * Alias to set the "limit" value of the query.
    *
    * @param int value
    * @return NSFetchRequest
    */
    public static func take(value:Int) -> NSFetchRequest{
        return self.query.take(value)
    }
    
    /**
    * Set the limit and offset for a given page.
    *
    * @param int page
    * @param int perPage
    * @return NSFetchRequest
    */
    public static func forPage(page:Int,_ perPage:Int) -> NSFetchRequest{
        return self.query.forPage(page,perPage)
    }
    
    public static func all() -> [NSManagedObject] {
        return self.query.get()
    }
    
    public static func count() -> Int {
        return self.query.count()
    }
    
    public static func findAndUpdate(unique:[String:AnyObject],data:[String:AnyObject]) -> NSManagedObject?{
        if let object = self.find(unique) {
            object.update(data)
            return object
        }else{
            return nil
        }
    }
    
    public static func updateOrCreate(unique:[String:AnyObject],data:[String:AnyObject]) -> NSManagedObject{
        if let object = self.find(unique) {
            object.update(data)
            return object
        }else{
            return self.create(data)
        }
    }
    
    public static func findOrCreate(properties: [String:AnyObject]) -> NSManagedObject {
        let transformed = self.transformProperties(properties)
        let existing = self.find(properties)
        return existing ?? self.create(transformed)
    }
    
    public static func find(condition: AnyObject) -> NSManagedObject? {
        return self.query.condition(condition).first()
    }
    
    public func update(properties: [String:AnyObject]) {
        
        if (properties.count == 0) {
            return
        }
        let transformed = self.dynamicType.transformProperties(properties)
        //Finish
        for (key, value) in transformed {
            self.willChangeValueForKey(key)
            self.setSafeValue(value, forKey: key)
            self.didChangeValueForKey(key)
        }
    }
    
    public func save() -> Bool {
        return self.defaultContext().saveData()
    }
    
    public func delete() -> NSManagedObjectContext {
        let context = self.defaultContext()
        context.deleteObject(self)
        return context
    }
    
    public static func deleteAll() -> NSManagedObjectContext{
        for o in self.all() {
            o.delete()
        }
        return self.defaultContext()
    }
    
    public static func create() -> NSManagedObject {
        let o = NSEntityDescription.insertNewObjectForEntityForName(self.entityName(), inManagedObjectContext: self.defaultContext()) 
        if let idprop = self.autoIncrementingId() {
            o.setPrimitiveValue(NSNumber(integer: self.nextId()), forKey: idprop)
        }
        return o
    }
    
    public static func create(properties: [String:AnyObject]) -> NSManagedObject {
        let newEntity: NSManagedObject = self.create()
        newEntity.update(properties)
        if let idprop = self.autoIncrementingId() {
            if newEntity.primitiveValueForKey(idprop) == nil {
                newEntity.setPrimitiveValue(NSNumber(integer: self.nextId()), forKey: idprop)
            }
        }
        return newEntity
    }
    
    public static func autoIncrements() -> Bool {
        return self.autoIncrementingId() != nil
    }
    
    public static func nextId() -> Int {
        let key = "SwiftRecord-" + self.entityName() + "-ID"
        if self.autoIncrementingId() != nil {
            let id = NSUserDefaults.standardUserDefaults().integerForKey(key)
            NSUserDefaults.standardUserDefaults().setInteger(id + 1, forKey: key)
            return id
        }
        return 0
    }
    

    public class func autoIncrementingId() -> String? {
        return nil
    }
    
    //Private
    
    private static func transformProperties(properties: [String:AnyObject]) -> [String:AnyObject]{
        let entity = NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: self.defaultContext())!
        let attrs = entity.attributesByName
        let rels = entity.relationshipsByName
        
        var transformed = [String:AnyObject]()
        for (key, value) in properties {
            let localKey = self.keyForRemoteKey(key)
            if attrs[localKey] != nil {
                transformed[localKey] = value
            } else if let rel = rels[localKey]  {
                if EasyORM.generateRelationships {
                    if rel.toMany {
                        if let array = value as? [[String:AnyObject]] {
                            transformed[localKey] = self.generateSet(rel, array: array)
                        } else {
                            #if DEBUG
                                println("Invalid value for relationship generation in \(NSStringFromClass(self)).\(localKey)")
                                println(value)
                            #endif
                        }
                    } else if let dict = value as? [String:AnyObject] {
                        transformed[localKey] = self.generateObject(rel, dict: dict)
                    } else {
                        #if DEBUG
                            println("Invalid value for relationship generation in \(NSStringFromClass(self)).\(localKey)")
                            println(value)
                        #endif
                    }
                }
            }
        }
        return transformed
    }
    
    
    private func setSafeValue(value: AnyObject?, forKey key: String) {
        if (value == nil) {
            self.setNilValueForKey(key)
            return
        }
        let val: AnyObject = value!
        if let attr = self.entity.attributesByName[key] {
            let attrType = attr.attributeType
            if attrType == NSAttributeType.StringAttributeType && value is NSNumber {
                self.setPrimitiveValue((val as! NSNumber).stringValue, forKey: key)
            } else if let s = val as? String {
                if self.isIntegerAttributeType(attrType) {
                    self.setPrimitiveValue(NSNumber(integer: val.integerValue), forKey: key)
                    return
                } else if attrType == NSAttributeType.BooleanAttributeType {
                    self.setPrimitiveValue(NSNumber(bool: val.boolValue), forKey: key)
                    return
                } else if (attrType == NSAttributeType.FloatAttributeType) {
                    self.setPrimitiveValue(NSNumber(floatLiteral: val.doubleValue), forKey: key)
                    return
                } else if (attrType == NSAttributeType.DateAttributeType) {
                    self.setPrimitiveValue(self.dynamicType.dateFormatter.dateFromString(s), forKey: key)
                    return
                }
            }
        }
        self.setPrimitiveValue(value, forKey: key)
    }
    
    private func isIntegerAttributeType(attrType: NSAttributeType) -> Bool {
        return attrType == NSAttributeType.Integer16AttributeType || attrType == NSAttributeType.Integer32AttributeType || attrType == NSAttributeType.Integer64AttributeType
    }
    
    private static var dateFormatter: NSDateFormatter {
        if _dateFormatter == nil {
            _dateFormatter = NSDateFormatter()
            _dateFormatter!.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        }
        return _dateFormatter!
    }
    private static var _dateFormatter: NSDateFormatter?
    
    
    public class func mappings() -> [String:String] {
        return [String:String]()
    }
    
    public static func keyForRemoteKey(remote: String) -> String {
        if let s = cachedMappings[remote] {
            return s
        }
        let entity = NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: self.defaultContext())!
        let properties = entity.propertiesByName
        if properties[remote] != nil {
            _cachedMappings![remote] = remote
            return remote
        }
        
        let camelCased = remote.camelCase
        if properties[camelCased] != nil {
            _cachedMappings![remote] = camelCased
            return camelCased
        }
        _cachedMappings![remote] = remote
        return remote
    }
    private static var cachedMappings: [String:String] {
        if let m = _cachedMappings {
            return m
        } else {
            var m = [String:String]()
            for (key, value) in mappings() {
                m[value] = key
            }
            _cachedMappings = m
            return m
        }
    }
    private static var _cachedMappings: [String:String]?
    
    private static func generateSet(rel: NSRelationshipDescription, array: [[String:AnyObject]]) -> NSSet {
        var cls: NSManagedObject.Type?
        if EasyORM.nameToEntities.count > 0 {
            cls = EasyORM.nameToEntities[rel.destinationEntity!.managedObjectClassName]
        }
        if cls == nil {
            cls = (NSClassFromString(rel.destinationEntity!.managedObjectClassName) as! NSManagedObject.Type)
        } else {
            print("Got class name from entity setup")
        }
        let set = NSMutableSet()
        for d in array {
            set.addObject(cls!.findOrCreate(d))
        }
        return set
    }
    
    private static func generateObject(rel: NSRelationshipDescription, dict: [String:AnyObject]) -> NSManagedObject {
        let entity = rel.destinationEntity!
        
        let cls: NSManagedObject.Type = NSClassFromString(entity.managedObjectClassName) as! NSManagedObject.Type
        return cls.findOrCreate(dict)
    }
    
    public static func primaryKey() -> String {
        NSException(name: "Primary key undefined in " + NSStringFromClass(self), reason: "Override primaryKey if you want to support automatic creation, otherwise disable this feature", userInfo: nil).raise()
        return ""
    }
    
    private static func entityName() -> String {
        var name = NSStringFromClass(self)
        if name.rangeOfString(".") != nil {
            let comp = name.characters.split {$0 == "."}.map { String($0) }
            if comp.count > 1 {
                name = comp.last!
            }
        }
        if name.rangeOfString("_") != nil {
            var comp = name.characters.split {$0 == "_"}.map { String($0) }
            var last: String = ""
            var remove = -1
            for (i,s) in Array(comp.reverse()).enumerate() {
                if last == s {
                    remove = i
                }
                last = s
            }
            if remove > -1 {
                comp.removeAtIndex(remove)
                name = comp.joinWithSeparator("_")
            }
        }
        return name
    }
}

public extension String {
    var camelCase: String {
        let spaced = self.stringByReplacingOccurrencesOfString("_", withString: " ", options: [], range:Range<String.Index>(start: self.startIndex, end: self.endIndex))
        let capitalized = spaced.capitalizedString
        let spaceless = capitalized.stringByReplacingOccurrencesOfString(" ", withString: "", options:[], range:Range<String.Index>(start:self.startIndex, end:self.endIndex))
        return spaceless.stringByReplacingCharactersInRange(Range<String.Index>(start:spaceless.startIndex, end:spaceless.startIndex.successor()), withString: "\(spaceless[spaceless.startIndex])".lowercaseString)
    }
}
