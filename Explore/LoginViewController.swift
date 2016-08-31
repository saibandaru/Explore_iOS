////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  LoginViewController.swift                                     //
//  Created by Sai Krishna Bandaru on 4/9/16.                     //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit
//The imports are for FaceBook and FireBase kits
import FBSDKLoginKit
import Firebase

//The main Login Screen
class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    //Facebook button on the login page
    @IBOutlet weak var facebookSignIn: FBSDKLoginButton!
    
    //Firebase root handle and Userinfo handle
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var userHandle = Firebase(url:"https://explore-app.firebaseio.com")
    
    
    //ViewControllers viewDidLoad method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Background Image load
        //var image_bg = UIImage(named:"login_bg.jpg")
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_home.jpg")!)
        self.addBackground()
        facebookSignIn.delegate=self
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
       
        self.alreadySinedIn()
    }

    //ViewControllers didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //already signed in bypass login screen
    func alreadySinedIn(){
        self.alreadySignedInFacebook()
        self.customFirebaseSignedIn()
    }
    
    //background image
    func addBackground() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "bg_home.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
    }
    
    //dismiss keyboard
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    // MARK: FaceBook Login
    
    //when login is successful
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        
        if(FBSDKAccessToken.currentAccessToken() != nil){
            
            print("Facebook signed in")
            //update user info to firebase if user is new user
            self.updateFBuserinFire()
             //load home screen after successful login
            self.loadHomeAfterSignIn()
        }
        
    }
    
    //when logout is successful
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        
        print("Facebook Logout")
        
    }

    //check if user already signed in with Facebook
    func alreadySignedInFacebook(){
        
        if(FBSDKAccessToken.currentAccessToken() != nil){
            
            print("Facebook User has already logged in *VC*")
            //update user info to firebase if user is new user
            self.updateFBuserinFire()
            //load home screen after successful login
            self.loadHomeAfterSignIn()
        }else{
            print("Facebook User hasnt logged in *VC*")
        }
        
    }
    
    //Update Firebase with new Facebook user info
    func updateFBuserinFire(){
        
        if(FBSDKAccessToken.currentAccessToken() != nil){
            
            print(FBSDKAccessToken.currentAccessToken())
            userHandle = myRootRef.childByAppendingPath("data/users/\(FBSDKAccessToken.currentAccessToken().userID)")
            userHandle.observeEventType(.Value, withBlock: { snapshot in
                print(snapshot.value)
                if(String(snapshot.value) == "<null>"){
                    self.userHandle = self.myRootRef.childByAppendingPath("data/users/")
                    self.insertUserInCloud("\(FBSDKAccessToken.currentAccessToken().userID)",email:"\(FBSDKAccessToken.currentAccessToken().userID)@explore.com")
                    self.userHandle = self.myRootRef.childByAppendingPath("data/users/\(FBSDKAccessToken.currentAccessToken().userID)")
                    self.constructProfile()
                }
                
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
    }
    
    //insert FBUser into Firebase
    func insertUserInCloud(uid:String,email:String){
        
        let emailVal = ["email_exp":email]
        let insertVal = [uid:emailVal]
        self.userHandle.updateChildValues(insertVal)
        
    }
    
    //construct FBUser into Firebase
    func constructProfile(){
        
        if(userHandle != nil){
            let name = [ ("username") : "Not Given"]
            self.userHandle.updateChildValues(name)
            let mobileNo = ["mobile":"Not Given"]
            self.userHandle.updateChildValues(mobileNo)
            let mail = ["mailID":"Not Given"]
            self.userHandle.updateChildValues(mail)
            let status_ = ["status":"Not Given"]
            self.userHandle.updateChildValues(status_)
        }
    }
    
    
    // MARK: Custom Login
    
    //username field handle
    @IBOutlet weak var userName: UITextField!
    
    //password field handle
    @IBOutlet weak var password: UITextField!
    
    //description field handle
    @IBOutlet weak var descrTV: UILabel!
    
    //custom login button handle
    @IBAction func login(sender: UIButton) {
        
        let finalUname = userName.text! + "@explore.com"
        myRootRef.authUser(finalUname, password: password.text,
            withCompletionBlock: { error, authData in
                if error != nil {
                    self.handleLoginErrors(error.code)
                    print("Failed to login ")
                    print("\(error)")
                } else {
                    print("login successful")
                    self.descrTV.text = "Logged In"
                    self.loadHomeAfterSignIn()
                }
        })
    }
    
//    //Guest test button
//    @IBAction func alreadySignedInCuston(sender: UIButton){
//        
//        if(myRootRef.authData == nil){
//            self.descrTV.text = "not logged in"
//            print("Custom User hasnt logged in *VC*")
//        }else
//        {
//            self.descrTV.text = "already logged in"
//            print("Custom User has logged in *VC*")
//            loadHomeAfterSignIn()
//        }
//    }
    
    func customFirebaseSignedIn(){
        if(myRootRef.authData == nil){
            print("Custom User hasnt logged in *VC*")
        }else
        {
            print("Custom User has logged in *VC*")
            loadHomeAfterSignIn()
        }
    }
    
    // MARK: Utilities functions
    
    //load the Home Screen if user has already signed in
    func loadHomeAfterSignIn(){
        
        let nav : UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("HomeTabView") as! UITabBarController
        self.presentViewController(nav, animated: true, completion: nil)
    }

    //display login errors in description field
    func handleLoginErrors(code:Int){
        
        if(code == -8){
            self.descrTV.text = "User doesn't exists"
        }else if(code == -6){
            self.descrTV.text = "Password Incorrect"
        }else{
            self.descrTV.text = "Error Code:"+String(code)
        }
    }
    
    // MARK: Remove Stuff
    
    // travel to sague by replacing root
    func trans(){

        let resultController = (self.storyboard?.instantiateViewControllerWithIdentifier("HomePrimaryVC"))!
        let appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        appDelegate.window?.rootViewController = resultController
        
    }
    
    //logout from firebase
    func logout_Fire(sender: AnyObject) {
        
        myRootRef.unauth()
        self.descrTV.text = "Logged Out"
    }

}

