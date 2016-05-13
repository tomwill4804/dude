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
    private var parks : [Park]!
    
    //
    //  initial setup
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.parks = Array()
        self.currentLocation()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let data = defaults.objectForKey("lastPark") as? NSData {
            
            let park = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! Park
            let pin = MapPin(coordinate: park.location.coordinate, title: park.name, subtitle: park.description)
            
            mapView.addAnnotation(pin)
            
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
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
    }
    
    //
    //
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showParks" {
            let vc = (segue.destinationViewController as! UINavigationController).topViewController as! ParksTableViewController
            vc.parks = parks
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
        
        let park = Park()
        park.name = act.textFields![0].text
        park.desc = act.textFields![1].text
        park.location = mapView.userLocation.location
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(park)
        
        defaults.setObject(data, forKey: "lastPark")
        parks.append(park)
        
    }
    
 


}

