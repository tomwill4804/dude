//
//  Mapper.swift
//  Dude
//
//  Created by Tom Williamson on 5/15/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit
import MapKit

class Mapper: NSObject,CLLocationManagerDelegate {
    
    var mapView : MKMapView
    private var manager : CLLocationManager
    var currentLocation : CLLocation?
    private var lastLocation : Park?
    
    
    //
    //  init the object
    //
    init(mapView:MKMapView, lastLocation: Park?) {
        
        self.mapView = mapView
        self.lastLocation = lastLocation
    
        //
        //  create a location manager
        //
        manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        super.init()
        manager.delegate = self
        
    }
    
    
    //
    //  update current location on the map
    //
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            
            let location = locations.last
            currentLocation = location
            
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
            if lastLocation != nil {
                lastLocation?.markOnMap(mapView)
                self.zoom(currentLocation!, secondLoc: (lastLocation?.location)!)
            }
        }
        
    }
    
    //
    //  zoom to two locations on a map
    //
    func zoom(firstLoc : CLLocation, secondLoc : CLLocation) {
        
        let lat = (firstLoc.coordinate.latitude + secondLoc.coordinate.latitude) / 2
        
        let longitude = (firstLoc.coordinate.longitude + secondLoc.coordinate.longitude) / 2
        
        
        let distance = firstLoc.distanceFromLocation(secondLoc)
        let centerLocation = CLLocation.init(latitude: lat, longitude: longitude)
        
        if CLLocationCoordinate2DIsValid(centerLocation.coordinate) {
            let region = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, distance, distance)
            self.mapView.setRegion(region, animated: true)
        }
    }
    


}
