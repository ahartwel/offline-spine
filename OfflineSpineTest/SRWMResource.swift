//
//  SRWMResource.swift
//  OfflineSpineTest
//
//  Created by Alex Hartwell on 1/16/17.
//  Copyright © 2017 hartwell. All rights reserved.
//

import Foundation
import Spine
import Dollar

//public required init(coder: NSCoder) {
//    super.init()
//    self.id = coder.decodeObject(forKey: "id") as? String
//    self.url = coder.decodeObject(forKey: "url") as? URL
//    self.isLoaded = coder.decodeBool(forKey: "isLoaded")
//    self.meta = coder.decodeObject(forKey: "meta") as? [String: AnyObject]
//    
//    if let relationshipsData = coder.decodeObject(forKey: "relationships") as? [String: NSDictionary] {
//        var relationships = [String: RelationshipData]()
//        for (key, value) in relationshipsData {
//            relationships[key] = RelationshipData.init(dictionary: value)
//        }
//    }
//}


class TestObject: SWRMResource {
    var title: String?
    var desc: String?
    
    
    override class var resourceType: ResourceType {
        return "TestObject";
    }
    
    override var type: Resource.Type {
        get {
            return TestObject.self;
        }
    }
    
    override class var fields: [Field] {
        return fieldsFromDictionary([
            "title": Attribute(),
            "desc": Attribute()
            ]);
    }
    
}


var ResourceCache: [String: [Resource]] = [:];

class SWRMResource: Resource {
    
    /// exposing the resource type so we can get the fields
    var type: Resource.Type {
        get {
            assertionFailure("didn't set the resource's type");
            return SWRMResource.self;
        }
    }
    
    static var cache: [Resource] = [];
    
    
    public required init(coder: NSCoder) {
        super.init(coder: coder);
        let mirror = Mirror(reflecting: self);
        for child in mirror.children { //mirror the object so we can loop through the object'ss properties and get the saved values
            if let name = child.label {
                let value = coder.decodeObject(forKey: name); //get the encoded property value
                setValue(value, forKeyPath: name); //set the property
            }
        }
    }
    
    override open func encode(with coder: NSCoder) {
        super.encode(with: coder);
        for field in self.type.fields {
            coder.encode(value(forKey: field.name) as Any, forKey: field.name)
        }
    }

    
    required init() {
        super.init();
    }
    
    
    func saveToCache() {
        if ResourceCache[self.type.resourceType] == nil {
            ResourceCache[self.type.resourceType] = [];
        }
        
        let ar = $.remove(ResourceCache[self.type.resourceType]!, callback: {
            return $0.id! == self.id!;
        });
        ResourceCache[self.type.resourceType] = ar;
        ResourceCache[self.type.resourceType]!.append(self);

        let data = NSKeyedArchiver.archivedData(withRootObject: ResourceCache[self.type.resourceType]!);
        UserDefaults.standard.setValue(data, forKeyPath: self.type.resourceType);
    }
    
    func getAllObjectsInCache<T: Resource>() -> [T] {
        if let data = UserDefaults.standard.object(forKey: TestObject.resourceType) as? Data {
            if let objs = NSKeyedUnarchiver.unarchiveObject(with: data) as? [T] {
                ResourceCache[self.type.resourceType] = objs;
                return objs;
            }
        }
        return [];
    }
    
    
}
