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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        

    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    @IBAction func dropPin(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print(action)
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            print(action)
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


}

