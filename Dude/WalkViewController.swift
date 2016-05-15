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
    
    private var mapper : Mapper?
    private var startLocation : CLLocation?
    var park : Park!

    //
    //  initial setup
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = park.name
        mapper = Mapper(mapView: mapView, lastLocation: park, directions: directions)

    }
    
    
    
    //
    //  generate directions between two points
    //  this is called from the mapper object once we get the
    //  current location
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
