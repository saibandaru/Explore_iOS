//
//  AppDelegate.swift
//  Explore
//
//  Created by Sai on 4/11/16.
//  Copyright © 2016 Sai Krishna. All rights reserved.
//

import UIKit
//For facebook login
import FBSDKCoreKit
import FBSDKLoginKit
//For Auto Fill place
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //return true
        // Mark: Theme set
        var bgColor = UIColor.whiteColor()
        let col = Colors()
        bgColor = col.UIColorFromRGB(0x1C8D47)
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = bgColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // Mark: Theme set end
        GMSServices.provideAPIKey("AIzaSyCFNnFvKpw2xV8KH0dZX3tqHcmB8BkbhR8")
        FBSDKLoginButton.classForCoder()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication,
        openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {

            if (FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)){
                return true;
            }
            return false;
            
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

