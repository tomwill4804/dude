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
        static let imageKey = "image"
        static let dateKey = "date"
        static let addressKey = "address"
    }
    
    //
    //  properties
    //
    var name: String? = ""
    var desc: String? = ""
    var location: CLLocation?
    var image: UIImage?
    var date: NSDate?
    var address: String? = ""
    
    //
    //  serialize the object
    //
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(desc, forKey: PropertyKey.descriptionKey)
        aCoder.encodeObject(location, forKey: PropertyKey.locationKey)
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(address, forKey: PropertyKey.addressKey)
        
    }
    
    //
    //  convert serialized object
    //
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as? String
        desc = aDecoder.decodeObjectForKey(PropertyKey.descriptionKey) as? String
        location = aDecoder.decodeObjectForKey(PropertyKey.locationKey) as? CLLocation
        image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as? UIImage
        date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        address = aDecoder.decodeObjectForKey(PropertyKey.addressKey) as? String
        
    }
    
    func markOnMap(mapView:MKMapView) {
        
        let pin = MapPin(coordinate: self.location!.coordinate, title: self.name, subtitle: self.desc)
        mapView.addAnnotation(pin)
        
    }


}
