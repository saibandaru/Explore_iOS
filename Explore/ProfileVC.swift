////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  ProfileVC.swift                                               //
//  Created by Sai Krishna Bandaru on 4/17/16.                    //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit
//imports for Firebase abd Facebook kits
import Firebase
import FBSDKLoginKit

//User profile Screen
class ProfileVC:UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //section header names
    let section_h = ["profile","username","mobileNumber","e-mail","status","Logout"]
    
    //no of sections 
    let section_number = 6
    
    //Firebase root handle and Userinfo handle
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var createUserRef = Firebase(url:"https://explore-app.firebaseio.com")
    var imageRefDload = Firebase(url:"https://explore-app.firebaseio.com")
    
    //datastore to capture user profile info
    var profileInfo : UserInfoParse!
    
    //capture profilepic
    var profile_pic:UIImage!
    
    //default proile image
    var pic_name = "profile.jpg"
    
    // MARK: TableView DataSource Protocol
    
    //no of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return section_number;
        
    }
    
    //no of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1;
    }
    
    //content of each cell ath coresponding section,row pair
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell
        if(indexPath.section==0){
            
            var cell_ : DPCell
            cell_=tableView.dequeueReusableCellWithIdentifier("cell",forIndexPath:indexPath) as! DPCell
            cell_.imageDP.image = profile_pic//   textLabel?.text=str;
            cell_.imageDP.layer.cornerRadius = cell_.imageDP.frame.size.width / 2;
            cell_.imageDP.clipsToBounds = true;
            return cell_
        }
        else if(indexPath.section==1){
            cell=tableView.dequeueReusableCellWithIdentifier("cell_text",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text=self.profileInfo.username;
        }
        else if(indexPath.section==2)
        {
            cell=tableView.dequeueReusableCellWithIdentifier("cell_text",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text=self.profileInfo.mobile;
        }
        else if(indexPath.section==3){
            cell=tableView.dequeueReusableCellWithIdentifier("cell_text",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text=self.profileInfo.mailID;
        }
        else if(indexPath.section==4){
            cell=tableView.dequeueReusableCellWithIdentifier("cell_text",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text=self.profileInfo.status;
        }
        else if(indexPath.section==5){
            let cell_=tableView.dequeueReusableCellWithIdentifier("cell_logout",forIndexPath:indexPath) as! LogoutCell
            let tap_s = UITapGestureRecognizer(target: self, action: Selector("logoutHandle:"))
            tap_s.numberOfTapsRequired = 1
            cell_.logoutButton.addGestureRecognizer(tap_s)
            return cell_
        }
        else{
            cell=tableView.dequeueReusableCellWithIdentifier("cell_text",forIndexPath:indexPath) as UITableViewCell
        }
        return cell;
    }
    
    //height of cell at each section index
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0) {
            return 100;
        }
        else {
            return 50
        }
    }
    
    //height of header at each section index
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    //header for each section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //var str:String;
        if(section < section_number){
            return section_h[section];
        }
        return "default";
    }
    
    //deselect tableview once selection is one
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //tableview outlet for making the delegate to self and to refresh/reload data
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: ViewController Methods
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        profileInfo = UserInfoParse(dictionary: NSDictionary())
        // Do any additional setup after loading the view, typically from a nib.
         self.title = "Profile"
        self.profile_pic = UIImage(named:pic_name)
        tableView.delegate = self
        userStatus()
    }
    
    //didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Utilities methods
    
    //Update user profile info
    func userStatus(){
        
        if(myRootRef.authData != nil || FBSDKAccessToken.currentAccessToken() != nil ){
            var userID :String = ""
            if(myRootRef.authData != nil ){
                userID = myRootRef.authData.uid!
            }else{
                userID = FBSDKAccessToken.currentAccessToken().userID
            }
            createUserRef = myRootRef.childByAppendingPath("data/users/\(userID)")
            imageRefDload = myRootRef.childByAppendingPath("data/profilepics/\(userID)")
            createUserRef.observeEventType(.Value, withBlock: { snapshot in
                //if(snapshot.value as! String != "<null>"){                                            //to check
                self.profileInfo.setUsername_(snapshot.value.objectForKey("username"))
                self.profileInfo.setMailId_(snapshot.value.objectForKey("mailID"))
                self.profileInfo.setMobile_(snapshot.value.objectForKey("mobile"))
                self.profileInfo.setStatus_(snapshot.value.objectForKey("status"))
                self.tableView.reloadData()
                //}
                }, withCancelBlock: { error in
                    print(error.description)
            })
            self.dloadpp()
        }
        else {
            print("Not a valid user")
            //guest or ask to login again
        }
    }
    
    //download profile pic
    //download profileimage and set
    func dloadpp(){
        imageRefDload.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.value)
            if(String(snapshot.value) != "<null>"){
                let decodedData = NSData(base64EncodedString: snapshot.value as! String , options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                
                let decodedImage = UIImage(data: decodedData!)
                self.profile_pic = decodedImage
                self.tableView.reloadData()
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    //to handle logout button tap
    func logoutHandle(sender: UITapGestureRecognizer) {
        
        if(logout_Fire()){
            self.loadLoginSignOut()
        }
    }
    
    //firebase and facebook logout
    func logout_Fire()->Bool {
        
        if(myRootRef.authData != nil){
            myRootRef.unauth()
            print("FireBase User Logged out")
            return true
        }else if(FBSDKAccessToken.currentAccessToken() != nil){
            print("Facebook User hasnt logged in *VC*")
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            return true
        }else{
            print("Guest User")
            //Pop up to login
            return false
        }
    }
    
    // MARK: Navigation Methods
    
    //Tableview cell selected
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        

        let indexPath = self.tableView.indexPathForSelectedRow!
        if(indexPath.section == 0 ){
            let profileDPEdit = segue.destinationViewController as! DisplayImageVC
            profileDPEdit.profile_pic = self.profile_pic
            profileDPEdit.hidesBottomBarWhenPushed = true
            
        }else if(indexPath.section > 0 && indexPath.section < 5){
            let profileEdit = segue.destinationViewController as! ProfileEditVC
            let cell = sender as! UITableViewCell
            profileEdit.editNumber = indexPath.section
            profileEdit.text = (cell.textLabel?.text)!
            //hide tab options options
            profileEdit.hidesBottomBarWhenPushed = true
            //profileEdit.navigationItem.hidesBackButton = true
            
        }
        //let buss = self.businesses[indexPath.row]
        //descriptivepage.businesses = buss
    }
    
    //load the Home Screen if user wishes to skip/next after load
    func loadLoginSignOut(){
        
        let nav : UINavigationController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
        self.presentViewController(nav, animated: true, completion: nil)
    }
    

    // MARK: Delect section has string to NSData
    
    func convertStringToNSData(str:String)->NSData{
        //var str = "Hello"
        let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        print("Data = \(data)")
        let dict = str.parseJSONString //as! NSDictionary
        print("dict = \(dict)")
        //print("unsme = \(dict["username"])")
        return data!
    }
}
