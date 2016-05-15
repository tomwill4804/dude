//
//  ParksTableViewController.swift
//  Dude
//
//  Created by Tom Williamson on 5/12/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit
import MapKit


class ParksTableViewController: UITableViewController {
    
    var startLocation : CLLocation?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    //
    //  show the walking directions
    //
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showWalk" {
            let vc = segue.destinationViewController as! WalkViewController
            
            let index = tableView.indexPathForSelectedRow?.row
            let park = parks[index!]
            vc.park = park
            
        }
    }


    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    //
    //  one two per parking location
    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return parks.count
        
    }
    
    //
    //  build cell for parking location
    //
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let parkCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ParkCell
        
        let park = parks[indexPath.row] as Park
        parkCell.configure(park, startLocation: startLocation)
        return parkCell
        
    }
    
    //
    //  allow edit
    //
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        return true
        
    }
    
    //
    //  delete the parking location
    //
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            parks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            
        }
    }
    


   

}
