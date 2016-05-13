//
//  WalkViewController.swift
//  Dude
//
//  Created by Tom Williamson on 5/13/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit
import MapKit

class WalkViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textLabel: UILabel!
    
    private var manager : CLLocationManager!
    private var startLocation : CLLocation?
    var park : Park!

    //
    //  initial setup
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = park.name
        self.currentLocation()

    }
    
    
    //
    //  get the users current location
    //
    func currentLocation(){
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        //
        //  add pin for parking location
        //
        let pin = MapPin(coordinate: park.location!.coordinate, title: park.name, subtitle: park.desc)
        mapView.addAnnotation(pin)
        
    }
    
    
    //
    //  update current location on the map
    //
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //
        //  see if we have a new starting location
        //
        if startLocation == nil {
            
            let location = locations.last
            startLocation = location
            
            let pin = MapPin(coordinate: startLocation!.coordinate, title: "Starting", subtitle: "")
            mapView.addAnnotation(pin)
            
            self.directions(startLocation!, secondLoc: park.location!)
            self.zoom(startLocation!, secondLoc: park.location!)
            
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

    
    
    //
    //  generate directions between two points
    //
    func directions(firstLoc : CLLocation, secondLoc : CLLocation) {
        
        //
        //  build two placemarks
        //
        
        let request = MKDirectionsRequest()
        
        let placemark1 = MKPlacemark.init(coordinate: firstLoc.coordinate, addressDictionary:nil)
        request.source = MKMapItem.init(placemark: placemark1)
        
        let placemark2 = MKPlacemark.init(coordinate: secondLoc.coordinate, addressDictionary:nil)
        request.destination = MKMapItem.init(placemark: placemark2)
        
        request.requestsAlternateRoutes = false
        request.transportType = .Walking
        let directions = MKDirections.init(request: request)
        
        
        //
        //  start generating the directions
        //
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            if error != nil {
                NSLog(error!.localizedDescription)
            } else {
                
                let route = response!.routes[0]
                let distance = route.distance * 0.000621371192;
                self.textLabel.text = "Walking distance is \(distance) miles"
                
                self.showRoutes(response!)
            }
        })
        
    }
    
    
    //
    //  update the map for the directions
    //
    func showRoutes(response:MKDirectionsResponse) {
        
        for route in response.routes
        {
            mapView.addOverlay(route.polyline, level: .AboveRoads)
        }
    }
    
    //
    //  draw the line for the map route
    //
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let pr = MKPolylineRenderer(overlay: overlay)
        pr.strokeColor = UIColor.blueColor()
        pr.lineWidth = 5
        
        return pr
        
    }
    
    
}
