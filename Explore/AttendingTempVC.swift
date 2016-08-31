////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur        on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit
import Firebase
import FBSDKLoginKit

class AttendingTempVC: UIViewController {
    
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    
    var user = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.get_CurrUser()
        self.loadViewExpScreen()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.get_CurrUser()
        self.loadViewExpScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //get current user details
    func get_CurrUser(){
        
        if(myRootRef.authData != nil || FBSDKAccessToken.currentAccessToken() != nil ){
            if(myRootRef.authData != nil ){
                self.user = myRootRef.authData.uid!
            }else{
                self.user = FBSDKAccessToken.currentAccessToken().userID
            }
        }
    }
    
    //load the Home Screen if user has already signed in
    func loadViewExpScreen(){
        
        let nav  = self.storyboard!.instantiateViewControllerWithIdentifier("ExperiencesVC") as! ExperiencesVC
        //self.navigationController?.presentViewController(nav, animated: true, completion: nil)
        nav.mode = 2
        nav.user = self.user
        //self.presentViewController(nav, animated: true, completion: nil)
        if let navigation = self.navigationController{
            navigation.pushViewController(nav, animated: false)
        }
        //performSegueWithIdentifier("CreateExperience", sender: self)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
