//
//  ParksTableViewController.swift
//  Dude
//
//  Created by Tom Williamson on 5/12/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit

class ParksTableViewController: UITableViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showWalk" {
            let vc = segue.destinationViewController as! WalkViewController
            
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! ParkCell
            
            let indexPath = tableView.indexPathForCell(cell)
            let park = parks[(indexPath?.row)!]
            vc.park = park
            
        }
    }



    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return parks.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let parkCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ParkCell
        
        let park = parks[indexPath.row] as Park
        parkCell.configure(park)
        return parkCell
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        return true
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            parks.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            
        }
    }
    


   

}
