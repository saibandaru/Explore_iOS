////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  ProfileEditVC.swift                                           //
//  Created by Sai Krishna Bandaru on 4/14/16.                    //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////


import UIKit
import Firebase
import FBSDKLoginKit

class ProfileEditVC: UIViewController {
    
    
    @IBOutlet weak var enteredText: UITextView!
    
    var editNumber = 0
    
    var text = ""
    
    var userToken = ""
    
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var userRef = Firebase(url:"https://explore-app.firebaseio.com")
    
    // MARK: ViewController Methods
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        self.title = editField()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "edit")
        enteredText.becomeFirstResponder()
        
        super.viewDidLoad()
        enteredText.scrollEnabled = false
        enteredText.text = text
        enteredText.scrollEnabled = true
        self.initalizeToUser()

        // Do any additional setup after loading the view.
    }

    //didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Utility Methods
    
    //edit handle function
    func edit(){
        if(enteredText.text != self.text){
            print("update")
            updateEdit()
        }
        
        
        print("tapped \(enteredText.text)")
    }
    
    //update corresponding field
    func updateEdit(){
        if(userToken != ""){
            var parameter = ""
            print("1")
            switch editNumber{
                case 1: parameter = "username"
                case 2: parameter = "mobile"
                case 3: parameter = "mailID"
                case 4: parameter = "status"
                default: return;
            }
            print("2")
            let name = [ (parameter) : (enteredText.text) as AnyObject]
            self.userRef.updateChildValues(name)
            self.navigationController?.popToRootViewControllerAnimated(true)

        }
    }
    
    //get the edit field
    func editField()->String{
        switch editNumber{
            case 1:return "User Name"
            case 2:return "Mobile Number"
            case 3:return "E-Mail ID"
            case 4:return "Status"
        default: return "Error"
        }
    }
    
    //user firebase handle initalization
    func initalizeToUser(){
        getToken()
        if(userToken != ""){
            userRef = myRootRef.childByAppendingPath("data/users/"+userToken)
            print(userRef.description)
        }
    }
    
    //get Facebook or Firebase user Token
    func getToken(){
        if(myRootRef.authData != nil || FBSDKAccessToken.currentAccessToken() != nil ){
            if(myRootRef.authData != nil ){
                userToken = myRootRef.authData.uid!
            }else{
                userToken = FBSDKAccessToken.currentAccessToken().userID
            }
        }
    }
    
    // MARK: Delete content
    
    //delete
    func delete(){
        //enteredText.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0)
        //enteredText.setContentOffset(CGPointZero, animated: false)
    }
    
    


}
