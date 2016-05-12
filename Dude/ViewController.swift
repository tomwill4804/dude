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
    
    var manager : CLLocationManager!
    var location : Location!
    
    //
    //  initial setup
    //
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
    //  user wants to mark there current location
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
        
        let location = Location(name: act.textFields![0].text, desc: act.textFields![1].text)
        let loc2 = Location()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(location!)
        
        defaults.setObject(data, forKey: "lastLocation")
        
    }
    
 


}

