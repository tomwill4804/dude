//
//  AppDelegate.swift
//  Dude
//
//  Created by Tom Williamson on 5/12/16.
//  Copyright © 2016 Tom Williamson. All rights reserved.
//

import UIKit

var parks : [Park] = Array()

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //
        //  read back our data and build Park objects
        //
        if let array = NSKeyedUnarchiver.unarchiveObjectWithFile(fPath("parks.txt")) {
            parks = array as! [Park]
        }
        
        return true
    
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
        self.saveData()
  
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
      
        self.saveData()
        
    }
    
    //
    //  save our data
    //
    func saveData() {
    
        NSKeyedArchiver.archiveRootObject(parks, toFile: fPath("parks.txt"))
        
    }
    
    //
    //  return file path for saving data
    //
    func fPath(file: String) -> String{
       
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        let documentsDirectory = paths[0]
        return documentsDirectory + "/" + file
        
    }
    
}

