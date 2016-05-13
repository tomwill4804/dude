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
    
    private var manager : CLLocationManager!
    private var startLocation : CLLocation?
    var park : Park!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        //
        //  see if we have a new starting location
        //
        if startLocation == nil {
            startLocation = location
            let pin = MapPin(coordinate: startLocation!.coordinate, title: "Starting", subtitle: "")
            mapView.addAnnotation(pin)
            self.directions(startLocation!, secondLoc: park.location!)
        }
        
    }
    
    func directions(firstLoc : CLLocation, secondLoc : CLLocation) {
        
        //
        //  generate directions from two points
        //
        
        let request = MKDirectionsRequest()
        
        let placemark1 = MKPlacemark.init(coordinate: firstLoc.coordinate, addressDictionary:nil)
        request.source = MKMapItem.init(placemark: placemark1)
        
        let placemark2 = MKPlacemark.init(coordinate: secondLoc.coordinate, addressDictionary:nil)
        request.destination = MKMapItem.init(placemark: placemark2)
        
        request.requestsAlternateRoutes = false
        request.transportType = .Walking
        let directions = MKDirections.init(request: request)
        
        directions.calculateDirectionsWithCompletionHandler ({
            (response: MKDirectionsResponse?, error: NSError?) in
            if error != nil {
                NSLog(error!.localizedDescription)
            } else {
                
                let route = response!.routes[0]
                let distance = route.distance * 0.000621371192;
                //Self.messageLabel.text = [NSString stringWithFormat:@"Walk is %g miles", distance];
                
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
