////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Sai Krishna Bandaru on 4/11/16.                    //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit
//imports for Facebook and Firebase kits
import FBSDKLoginKit
import Firebase



class HomeViewController: UIViewController {
    
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    
    @IBOutlet weak var accessToken: UILabel!
    
    var userToken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAccessToken()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAccessToken(){
        
            print("token \"\(userToken)\"")
            accessToken.text = userToken//String(FBSDKAccessToken.currentAccessToken().tokenString)
            //print()
            print("Facebook User hasnt logged in *VC*")
    }

    @IBAction func logoutFB(sender: AnyObject) {
        if(FBSDKAccessToken.currentAccessToken() != nil){
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }else if(myRootRef.authData != nil){
            myRootRef.unauth()
            loadBackHome()
        }
        
        
        

        
    }
    //.....To load back home
    func loadBackHome(){
        let vc : UINavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
        
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
             
    }
    
    
    
}
