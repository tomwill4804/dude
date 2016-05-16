//
//  ParkCell.swift
//  Dude
//
//  Created by Tom Williamson on 5/12/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit
import MapKit

class ParkCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    //
    //  build the cell
    //
    func configure(park : Park, startLocation : CLLocation?) {
        
        nameLabel.text = park.name
        descLabel.text = park.desc
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy HH:MM"
        dateLabel.text = dateFormatter.stringFromDate(park.date!)
        
        picture.image = park.image
        addressLabel.text = park.address
        
        if (startLocation != nil && park.location != nil) {
            let distanceMeters = startLocation!.distanceFromLocation(park.location!)
            var distance = distanceMeters * 0.000621371192;
            distance = round(100*distance/100)
            distanceLabel.text = "\(distance) miles away"
            
        }
        
    }
    

}
