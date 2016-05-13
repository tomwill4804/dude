//
//  ViewController.swift
//  Dude
//
//  Created by Tom Williamson on 5/12/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var manager : CLLocationManager!
    private var lastLocation : CLLocation?
    
    //
    //  initial setup
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Parking Locations"
        
        self.currentLocation()
        
        //
        //  annotate the last saved pin
        //
        if let park = parks.last {
            self.markOnMap(park)
        }
   
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
        
    }
    
    
    //
    //  update current location on the map
    //
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if lastLocation == nil {
           
            let location = locations.last
            lastLocation = location
            
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    //
    //
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showParks" {
            let vc = segue.destinationViewController as! ParksTableViewController
            vc.startLocation = lastLocation
        }
    }
    
    
    //
    //  back from show parks
    //
    @IBAction func unwindParksController(segue:UIStoryboardSegue) {
        
 
    }

    
    
    
    //
    //  user wants to mark their current location
    //
    @IBAction func dropPin(sender: AnyObject) {
        
        
        //
        //  prompt the user for title and description
        //
        let alertController = UIAlertController(title: "PIN Location", message: "Enter location description", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.okAction(alertController)
        }
        
        alertController.addAction(okAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Location"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Description"
        }

        
        self.presentViewController(alertController, animated: true) {
        
        }
    
        
    }
    
    //
    //  user pushed ok on pin prompt
    //
    func okAction(act:UIAlertController!) {
        
        if !act.textFields![0].text!.isEmpty {
            
            //
            //  create new Park object
            //
            let park = Park()
            park.name = act.textFields![0].text
            park.desc = act.textFields![1].text
            park.location = mapView.userLocation.location
            park.date = NSDate()
            
            //
            //  mark the spot on the map
            //
            self.markOnMap(park)
            
            //
            //  take snapshot of map (image)
            //
            let options = MKMapSnapshotOptions.init()
            options.region = mapView.region
            options.scale = UIScreen.mainScreen().scale
            options.size = CGSizeMake(300, 168)
            
            let snapshotter = MKMapSnapshotter.init(options: options)
            snapshotter.startWithCompletionHandler() {
                snapshot, error in
                
                park.image = snapshot!.image
                
            }
            
            //
            //  get address of location
            //
            CLGeocoder().reverseGeocodeLocation(park.location!, completionHandler: {(placemarks, error) -> Void in
                
                if placemarks!.count > 0 {
                    let pm = placemarks!.last
                    park.address = pm!.locality
                }
            
            })
            
            //
            //  save park in array
            //
            parks.append(park)
        }
        
    }
    
    func markOnMap(park:Park) {
    
        let pin = MapPin(coordinate: park.location!.coordinate, title: park.name, subtitle: park.desc)
        mapView.addAnnotation(pin)
    
    }
    
 


}

