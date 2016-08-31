////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  LoginViewController.swift                                     //
//  Created by Sai Krishna Bandaru on 4/9/16.                     //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit
//inport to access Firebase kit
import Firebase

//Create UserProfile Sague
class UserCreateProfileVC: UIViewController {
    
    //Firebase root handle and Userinfo handle
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var userRef = Firebase(url:"https://explore-app.firebaseio.com")
    
    //userToken UID
    var userToken = ""
    
    // MARK: ViewController Methods
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        add_boundaries()
        initalizeToUser()
        // Do any additional setup after loading the view.
    }

    //didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //add borders
    func add_boundaries(){
        let l_gray = UIColor.lightGrayColor()
        username.layer.borderColor = l_gray.CGColor
        username.layer.borderWidth = 1.0
        username.layer.cornerRadius = 5.0
        
        mobileNumber.layer.borderColor = l_gray.CGColor
        mobileNumber.layer.borderWidth = 1.0
        mobileNumber.layer.cornerRadius = 5.0
        
        mailID.layer.borderColor = l_gray.CGColor
        mailID.layer.borderWidth = 1.0
        mailID.layer.cornerRadius = 5.0
        
        status.layer.borderColor = l_gray.CGColor
        status.layer.borderWidth = 1.0
        status.layer.cornerRadius = 5.0

        
    }
    
    // MARK: ConstructUI handles
    
    //user Display image handle
    @IBOutlet weak var userDP: UIImageView!
    
    //username text field handle
    @IBOutlet weak var username: UITextField!
    
    //user mobilenumber text field handle
    @IBOutlet weak var mobileNumber: UITextField!
    
    //user mailid text field handle
    @IBOutlet weak var mailID: UITextField!
    
    //user status text field handle
    @IBOutlet weak var status: UITextField!
    
    //next button action handle
    @IBAction func setupProfile(sender: UIButton) {
        
        constructProfile()
        loadHomeAfterSignIn()
    }
    
    //skip button action handle
    @IBAction func skipProfile(sender: UIButton) {
        
        loadHomeAfterSignIn()
    }
    
    // MARK: Utility methods
    
    //user firebase handle initalization
    func initalizeToUser(){
        
        if(userToken != ""){
            userRef = myRootRef.childByAppendingPath("data/users/"+userToken)
            print(userRef.description)
        }
    }
    
    //construct profile information
    func constructProfile(){
        
        if(userToken != ""){
            let name = [ ("username") : (username.text) as! AnyObject]
            self.userRef.updateChildValues(name)
            let mobileNo = ["mobile":mobileNumber.text as! AnyObject]
            self.userRef.updateChildValues(mobileNo)
            let mail = ["mailID":mailID.text as! AnyObject]
             self.userRef.updateChildValues(mail)
            let status_ = ["status":self.status.text as! AnyObject]
            self.userRef.updateChildValues(status_)
        }
    }
       
    // MARK: Navigation Methods
    
    //load the Home Screen if user wishes to skip/next after load
    func loadHomeAfterSignIn(){
    
        let nav : UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeTabView") as! UITabBarController
        self.presentViewController(nav, animated: true, completion: nil)
    }
}
