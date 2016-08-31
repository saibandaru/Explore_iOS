////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  CreateUserViewController.swift                                //
//  Created by Pavan Kumar  on 4/9/16.                            //
//  Copyright © 2016 Ajith Kallur. All rights reserved.           //
////////////////////////////////////////////////////////////////////

import UIKit
//The import for FireBase kits
import Firebase

//This is for Create User Screen
class CreateUserViewController: UIViewController
{
    
    //Firebase root handle and Userinfo handle
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var createUserRef = Firebase(url:"https://explore-app.firebaseio.com")

    // MARK: ViewController Methods
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        super.viewDidLoad()
                self.title  =  "Create New User"
        self.add_boundaries()
        //to initalisr the user handle to users
        initalizeCUserFireHandle()
    }
    
    //didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //initalise the user firebase handle
    func initalizeCUserFireHandle(){
        
        createUserRef = myRootRef.childByAppendingPath("data/users")
    }
    
    //add borders
    func add_boundaries(){
        let l_gray = UIColor.lightGrayColor()
        userName.layer.borderColor = l_gray.CGColor
        userName.layer.borderWidth = 1.0
        userName.layer.cornerRadius = 5.0
        
        password.layer.borderColor = l_gray.CGColor
        password.layer.borderWidth = 1.0
        password.layer.cornerRadius = 5.0
        
        confirmPassword.layer.borderColor = l_gray.CGColor
        confirmPassword.layer.borderWidth = 1.0
        confirmPassword.layer.cornerRadius = 5.0
        
    }
    
    // MARK: create user section
    
    //error message text view handle

    
    @IBOutlet weak var messageText: UILabel!

    //username text view handle
    @IBOutlet weak var userName: UITextField!
    
    //password text view handle
    @IBOutlet weak var password: UITextField!
    
    //confirm pwd text view handle
    @IBOutlet weak var confirmPassword: UITextField!
    
    //create user button action handler
    @IBAction func createUser(sender: UIButton) {
        
        if(password.text == confirmPassword.text){
        
            let complete_un = userName.text! + "@explore.com"
            myRootRef.createUser(complete_un, password: password.text,
                withValueCompletionBlock: { error, result in
                    if error != nil {
                        self.messageText.text = error.description
                        
                    } else {
                        let uid = result["uid"] as? String
                        self.messageText.text = "User created successfully"
                        print("Successfully created user account with uid: \(uid)")
                        self.login(complete_un,password:self.password.text! )
                        self.insertUserInCloud(uid!,email: complete_un)
                        self.loaduserCreateProfile(uid!)
                    }
            })
        }else{
            self.messageText.text = "Password doesn't match"
            self.confirmPassword.text = ""
        }
    }
    
    //insert user into firebase database
    func insertUserInCloud(uid:String,email:String){
        
        let emailVal = ["email_exp":email]
        let insertVal = [uid:emailVal]
        self.createUserRef.updateChildValues(insertVal)
    }
    
    //make a self login after the user creates a new account
    func login(finalUname:String,password:String){
        
        myRootRef.authUser(finalUname, password: password,
            withCompletionBlock: { error, authData in
                if error != nil {
                    print("Failed to login ")
                    print("\(error)")
                } else {
                    print("login successful")
                }
        })
    }
    
    // MARK: Navigation methods
    
    //load the Home Screen if user has already signed in
    func loaduserCreateProfile(uid:String){
        let vc : UserCreateProfileVC = self.storyboard!.instantiateViewControllerWithIdentifier("userCreateProfileVC") as! UserCreateProfileVC
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
}
