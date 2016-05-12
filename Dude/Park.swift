//
//  Location.swift
//  Dude
//
//  Created by Tom Williamson on 5/12/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit
import MapKit

class Park: NSObject, NSCoding {
    
    
    struct PropertyKey {
        
        static let nameKey = "name"
        static let descriptionKey = "descrption"
        static let locationKey = "location"
    }
    
    var name: String!
    var desc: String!
    var location: CLLocation!
    
    //
    //  serialize the object
    //
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(desc, forKey: PropertyKey.descriptionKey)
        aCoder.encodeObject(location, forKey: PropertyKey.locationKey)
        
    }
    
    //
    //  convert serialized object
    //
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        self.name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        self.desc = aDecoder.decodeObjectForKey(PropertyKey.descriptionKey) as? String
        self.location = aDecoder.decodeObjectForKey(PropertyKey.locationKey) as? CLLocation
        
    }

}
