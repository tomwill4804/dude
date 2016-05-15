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
    
    private var mapper : Mapper?
    private var lastPark : Park?
    
    //
    //  initial setup
    //
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Parking Locations"
        
        //
        //  annotate the last saved pin
        //
        if let lastPark = parks.last {
            self.lastPark = lastPark
        }
        
        //
        //  start the mapper for this view
        //
        mapper = Mapper(mapView: mapView, lastLocation: lastPark, directions: nil)
        
    }
    
    
    //
    //  calling the show parking locations view controller
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showParks" {
            let vc = segue.destinationViewController as! ParksTableViewController
            vc.startLocation = mapper!.currentLocation
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
            park.markOnMap(mapView)
            
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


}

