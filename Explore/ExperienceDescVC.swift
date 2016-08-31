////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Sai Krishna Bandaru on 4/11/16.                    //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////
//

import UIKit
import CoreLocation
import Firebase
import FBSDKLoginKit
import Foundation
import MessageUI


class ExperienceDescVC: UIViewController,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate {
 
    var expData: ExperienceData!
    
    var user = ""

     @IBOutlet weak var tableView: UITableView!

    let arr = ["","Contact Host","Name","Description","Location","Date","Available Slots","Price","Status"]
 
    let sections = 9
    
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    
    var user_exp = Firebase(url:"https://explore-app.firebaseio.com")
    
    var get_user = Firebase(url:"https://explore-app.firebaseio.com")
    
    var mobile_number = [String]()

    
    var hosted_exp = [String]()
    
    var reg_exp = [String]()
    
    var identifier = -1
    
    var color_obj = Colors()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title  = "About Experience"
        tableView.delegate = self
        self.get_CurrUser()
        self.initalisze()
        self.load_exps()
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //initalise handles
    func initalisze(){
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
    }
    
    // MARK: TableView protocol methods
    
    //no of sections in TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections;
    }
    
    //no of rwosin each section of TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }
    
    //cell content for each row of tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell
        if(indexPath.section==1){
            let cell_=tableView.dequeueReusableCellWithIdentifier("calltextmap",forIndexPath:indexPath) as! CalltextmapCell
            //let tap_s = UITapGestureRecognizer(target: self, action: #selector(ExperienceDescVC.callHandle(_:)))
            let tap_s = UITapGestureRecognizer(target: self, action: Selector("callHandle:"))
            tap_s.numberOfTapsRequired = 1
            cell_.image1.image = UIImage(named: "call.jpeg")
            cell_.image1.userInteractionEnabled = true
            cell_.image1.addGestureRecognizer(tap_s)
            let tap_s2 = UITapGestureRecognizer(target: self, action: Selector("textHandle:"))
            //let tap_s2 = UITapGestureRecognizer(target: self, action: #selector(ExperienceDescVC.textHandle(_:)))
            tap_s2.numberOfTapsRequired = 1
            cell_.image2.image = UIImage(named: "message.jpg")
            cell_.image2.userInteractionEnabled = true
            cell_.image2.addGestureRecognizer(tap_s2)
            let tap_s3 = UITapGestureRecognizer(target: self, action: Selector("mapHandle:"))
            //let tap_s2 = UITapGestureRecognizer(target: self, action: #selector(ExperienceDescVC.textHandle(_:)))
            tap_s3.numberOfTapsRequired = 1
            cell_.image3.image = UIImage(named: "map.jpg")
            cell_.image3.userInteractionEnabled = true
            cell_.image3.addGestureRecognizer(tap_s3)
            return cell_
        }
        if(indexPath.section==0){
           // var cell_ :UITableViewCell
           let cell_=tableView.dequeueReusableCellWithIdentifier("Desp_cell1",forIndexPath:indexPath) as! Exp_DispCell
           
               cell_.exp_image.image  = expData.image
               cell_.exp_image.contentMode = .ScaleAspectFill
            return cell_
          // return cell
        }
        else if(indexPath.section==2){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text = (self.expData.expname);
        }
        else if(indexPath.section==3)
        {
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text =  (self.expData.expdesc )
        }
        else if(indexPath.section==4){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text = (self.expData.explocation)        }
        else if(indexPath.section==5){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text = (self.expData.expdate )
        }
        else if(indexPath.section==6){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text =  (self.expData.expavailableslots )
    
        }
        else if(indexPath.section==7){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            let expprice = (self.expData.expprice )
            cell.textLabel?.text = expprice
        }
        else if(indexPath.section==8){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.textColor = color_obj.UIColorFromRGB(0x1C8D47)
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            if(identifier == -1){
                cell.textLabel?.text = "Loading Status"
            }else if(identifier == 0){
                //let tap_s = UITapGestureRecognizer(target: self, action: #selector(ExperienceDescVC.registerHandle(_:)))
                let tap_s = UITapGestureRecognizer(target: self, action: Selector("registerHandle:"))
                tap_s.numberOfTapsRequired = 1
                cell.addGestureRecognizer(tap_s)
                cell.textLabel?.text = "Register"
            }else if(identifier == 1){
                cell.textLabel?.text = "You are Hosting"
            }else if(identifier == 2){
                cell.textLabel?.text = "Registered"
                //let tap_s = UITapGestureRecognizer(target: self, action: #selector(ExperienceDescVC.unregisterHandle(_:)))
                let tap_s = UITapGestureRecognizer(target: self, action: Selector("unregisterHandle:"))
                tap_s.numberOfTapsRequired = 1
                cell.addGestureRecognizer(tap_s)
            }
        }
        else{
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            
        }
        return cell;
    }
    
    //height of cell at index
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0) {
            return 200;
        }/*else if(indexPath.section == 8) {
            return 75;
        }*/
        else {
            return 50
        }
    }
    
    //height of the header at each section
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == 0){
            return 1
        }
        return 10
    }
    
    //header content for each section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section < self.sections){
            return arr[section]
        }
        return "default";
    }
    
    //deselect tableview once selection is one
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK : Utilites
    
    //register handle
    func registerHandle(sender: UITapGestureRecognizer) {
        
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
        user_exp = user_exp.childByAppendingPath("exp_reg")
        user_exp.childByAppendingPath(expData.getExpId_()).setValue("")
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
        self.load_exps()
        print("Register")
    }
    
    //unregister handle
    func unregisterHandle(sender: UITapGestureRecognizer) {
        
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
        user_exp = user_exp.childByAppendingPath("exp_reg/\(expData.getExpId_())")
        user_exp.removeValueWithCompletionBlock { (error, ref) in
            print("removed")
            self.user_exp = self.myRootRef.childByAppendingPath("data/users/\(self.user)")
            self.load_exps()
        }

        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
        ///self.load_exps()
        print("Register")
    }
    
    //register handle
    func callHandle(sender: UITapGestureRecognizer) {
        
        if let phoneURL = NSURL(string: "tel://\(self.mobile_number[0])")
        {
            UIApplication.sharedApplication().openURL(phoneURL)
        }
        print("Call Handle")
    }
    
    //Text handle
    func textHandle(sender: UITapGestureRecognizer) {
        
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Regarding Experience:\(self.expData.expname)\n"
            messageVC.recipients = self.mobile_number // Optionally add some tel numbers
            messageVC.messageComposeDelegate = self
            
            presentViewController(messageVC, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Oops!", message:"This feature isn't available right now", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
        print("Text Handle")
    }
    
    //Map handle
    func mapHandle(sender: UITapGestureRecognizer) {
        
        if(!(expData.location.coordinate.latitude == expData.location.coordinate.latitude && Int (expData.location.coordinate.latitude) == 0 )){
        
            let nav  = self.storyboard!.instantiateViewControllerWithIdentifier("MapExperienceVC") as! MapExperienceVC
            nav.location = self.expData.getLocation_()
            if let navigation = self.navigationController{
                navigation.pushViewController(nav, animated: false)
            }
        }else{
            print("location not given")
            self.view.makeToast("Exact location not given by host")

        }
        print("Map Handle")

    }
    
    //check user registered
    func check_exp(){
        let now_expId = expData.getExpId_()
        for exp in self.hosted_exp {
            if( exp == now_expId){
                self.identifier = 1     //1 for host
                self.tableView.reloadData()
                return
            }
        }
        for exp in self.reg_exp {
            if( exp == now_expId){
                self.identifier = 2     //1 for reg exp
                self.tableView.reloadData()
                return
            }
        }
        self.identifier = 0     //1 for open reg exp
        self.tableView.reloadData()
    }
    
    //get current user exp info
    func load_exps(){
        hosted_exp = [String]()
        reg_exp = [String]()    
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
        user_exp = user_exp.childByAppendingPath("exp_host")
        user_exp.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.description)
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                //print(rest.key)
                self.hosted_exp.append(String(rest.key))
            }
            self.check_exp()
            print(self.hosted_exp.count)
            }, withCancelBlock: { error in
                print(error.description)
        })
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
        
        user_exp = user_exp.childByAppendingPath("exp_reg")
        user_exp.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.description)
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                //print(rest.key)
                self.reg_exp.append(String(rest.key))
            }
            print(self.reg_exp.count)
            self.check_exp()
            }, withCancelBlock: { error in
                print(error.description)
        })
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")

    }
    
    //get current user details
    func get_CurrUser(){
        self.userInfo()
        if(myRootRef.authData != nil || FBSDKAccessToken.currentAccessToken() != nil ){
            if(myRootRef.authData != nil ){
                self.user = myRootRef.authData.uid!
            }else{
                self.user = FBSDKAccessToken.currentAccessToken().userID
            }
        }
    }
    
    //message view delegate
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResultCancelled.rawValue :
            print("message canceled")
            
        case MessageComposeResultFailed.rawValue :
            print("message failed")
            
        case MessageComposeResultSent.rawValue :
            print("message sent")
            
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Update user profile info
    func userInfo(){
        
        if(myRootRef.authData != nil || FBSDKAccessToken.currentAccessToken() != nil ){
            var userID :String = ""
            if(myRootRef.authData != nil ){
                userID = myRootRef.authData.uid!
            }else{
                userID = FBSDKAccessToken.currentAccessToken().userID
            }
            get_user = myRootRef.childByAppendingPath("data/users/\(userID)")
            get_user.observeEventType(.Value, withBlock: { snapshot in
                //if(snapshot.value as! String != "<null>"){                                            //to check
                //self.profileInfo.setUsername_(snapshot.value.objectForKey("username"))
                //self.profileInfo.setMailId_(snapshot.value.objectForKey("mailID"))
                //self.profileInfo.setMobile_(snapshot.value.objectForKey("mobile"))
                //self.profileInfo.setStatus_(snapshot.value.objectForKey("status"))
                //self.tableView.reloadData()
                //}
                self.mobile_number.append( snapshot.value.objectForKey("mobile") as! String)
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
        else {
            print("Not a valid user")
            //guest or ask to login again
        }
    }
}
    

