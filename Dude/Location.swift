//
//  Location.swift
//  Dude
//
//  Created by Tom Williamson on 5/12/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit

class Location: NSObject, NSCoding {
    
    
    struct PropertyKey {
        
        static let nameKey = "name"
        static let descriptionKey = "descrption"
    }
    
    var name: String!
    var desc: String!
    
    //
    //  serialize the object
    //
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(desc, forKey: PropertyKey.descriptionKey)
        
    }
    
    //
    //  convert serialized object
    //
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let desc = aDecoder.decodeObjectForKey(PropertyKey.descriptionKey) as? String
        
        self.init(name: name, desc: desc)
        
    }
    
    
    //
    //  init a new object
    //
    init?(name: String!, desc: String!) {
        
        self.name = name
        self.desc = desc
        
        super.init()
        
    }
    
}
