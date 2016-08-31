////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Sai Krishna Bandaru on 4/11/16.                    //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit
import Firebase
import FBSDKLoginKit
import Foundation
import GoogleMaps
import CoreLocation

class ExperiencesVC: UIViewController,UITableViewDataSource,UITableViewDelegate,GMSAutocompleteViewControllerDelegate {

    @IBOutlet weak var location: UITextField!

    var profile_pic : UIImage!
    
    var section_numbers = 1
    
    var city = "city"
    
    var city_search = "city"
    
    var place = "place"
    
    var user = "user"
    
    var exps = [ExperienceData]()
    
    var exps_host = [ExperienceData]()

    var exps_reg = [ExperienceData]()
    
    var mode :Int = 0
    
    var hosted_exp = [String]()
    
    var reg_exp = [String]()
    
    var scctionNames = ["Hosting","Registered"]
    
    var location_coord = CLLocation()

    
    @IBOutlet weak var tableView: UITableView!
    
    //Firebase root handle and Userinfo handle
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var accountRef = Firebase(url:"https://explore-app.firebaseio.com")
    var expPicRef = Firebase(url:"https://explore-app.firebaseio.com")
    var user_exp = Firebase(url:"https://explore-app.firebaseio.com")
    var tredning_exp = Firebase(url:"https://explore-app.firebaseio.com")

    
    // MARK: ViewController Methods
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        tableView.delegate = self
        let color_obj = Colors()
        self.location.textColor =  color_obj.UIColorFromRGB(0x1C8D47)
        super.viewDidLoad()
        self.run_experiences()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)

        // Do any additional setup after loading the view.
    }
    
    //didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Run experiences
    func run_experiences(){
        if(mode == 0){
            self.title = "Experiences"
            self.load_initLoc()
            self.initalise_ref()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "addExpScreen")
        }else if( mode == 1 ){
            self.title = "Experiences At"
            location.userInteractionEnabled = false
            print("False \(city_search)")
            self.initloc_exps()
            location.text = place
        }
        else if( mode == 2 ){
            self.navigationItem.setHidesBackButton(true, animated:true)
            location.userInteractionEnabled = false
            self.inituser_exps()
            self.title = "Attending"
            section_numbers = 2
            location.text = "Your Experiences"
        }
        else if( mode == 3 ){
            self.navigationItem.setHidesBackButton(true, animated:true)
            location.userInteractionEnabled = false
            self.init_trending()
            self.title = "Trending Experiences"
            location.text = "Top 20"
        }
    }
    
    //refresh pull
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        print("refresh")
        self.run_experiences()
        refreshControl.endRefreshing()
    }
    
    //add experience handle
    func addExpScreen(){
        
        let nav  = self.storyboard!.instantiateViewControllerWithIdentifier("CreateExpScreen1") as! CreateExperienceScreen1
        //self.navigationController?.presentViewController(nav, animated: true, completion: nil)
        nav.location = city_search
        nav.mode = 1
        nav.location_coord = location_coord
        nav.hidesBottomBarWhenPushed = true

        
        if let navigation = self.navigationController{
            print("exists")
            navigation.pushViewController(nav, animated: true)

            
        }
        //performSegueWithIdentifier("CreateExperience", sender: self)
    }

    
    // MARK: TableView DataSource Protocol
    
    //no of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return section_numbers;
        
    }
    
    //no of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(mode == 2){
            if(section == 0){
                if(exps_host.count == 0){
                    return 1
                }
                return exps_host.count
            }else{
                if(exps_reg.count == 0){
                    return 1
                }
                return exps_reg.count
            }
        }
        
        if(exps.count == 0){
            return 1
        }
        return exps.count;
    }
    
    //content of each cell ath coresponding section,row pair
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if((exps.count == 0 && mode != 2)||(exps_reg.count == 0 && mode == 2 && indexPath.section == 1) || (exps_host.count == 0 && mode == 2 && indexPath.section == 0)){
            let cell = UITableViewCell()
            let color_obj = Colors()
            cell.textLabel?.textColor   = color_obj.UIColorFromRGB(0x1C8D47)
            if mode != 2{
                cell.textLabel?.text = "No Experiences for this search"
            }else{
                cell.textLabel?.text = "No Experiences"
            }
            return cell
        }else{
            var cell :ExpCell
            var exp = ExperienceData()
            cell=tableView.dequeueReusableCellWithIdentifier("cell_exp",forIndexPath:indexPath) as! ExpCell
            
            if(mode == 0 || mode == 1 || mode == 3){
                exp = exps[indexPath.row]
            }else{
                if(indexPath.section == 0){
                    exp = exps_host[indexPath.row]
                }else{
                    exp = exps_reg[indexPath.row]
                }
            }
            
            cell.lable1.text = exp.getExpName_()
            cell.lable2.text = exp.getExpDesc_()
            cell.lable3.text = exp.getDate_()
            cell.displayImage.image = exp.getImage_()
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.displayImage.layer.cornerRadius = 5;
            cell.displayImage.clipsToBounds = true;
            cell.layer.borderWidth = 0.5
            let gray = UIColor.lightGrayColor()
            cell.layer.borderColor = gray.CGColor
            return cell;
        }
    }
    
    //height of the header at each section
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if mode == 2 {
            if(section == 0){
                return 20
            }
            return 10
        }
        return 1
    }
    
    //header content for each section
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if mode == 2{
            if(section < section_numbers){
                return scctionNames[section]
            }
        }
        return "";
    }
    
    //deselect tableview once selection is one
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Utilities
    
    //initalize profile
    func initalise_ref(){
        accountRef = myRootRef.childByAppendingPath("data/experiences/")
        expPicRef = myRootRef.childByAppendingPath("data/exp_pics/")
    }
    
    //
    func load_initLoc(){
        let loc = retriveLocation()
        location_coord = loc
        print(loc)
        getLocation_name(loc.coordinate.latitude, long: loc.coordinate.longitude)
    }
    
    //initialise location exp
    func initloc_exps(){
        self.initalise_ref()
        self.get_eid(self.city_search)
    }
    
    //initialise user exp
    func inituser_exps(){
        self.load_exps()
    }
    
    //initalize trending
    func init_trending(){
        self.getLatest()
    }
    
    var trending_exp = [String]()
    
    
    func getLatest(){
        exps = [ExperienceData]()
        trending_exp = [String]()
        
        tredning_exp = myRootRef.childByAppendingPath("data/trending/")
        tredning_exp.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.description)
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                print("\(rest.key)  \(rest.value)")
                self.trending_exp.append(String(rest.value))
            }
            let trend_new = self.trending_exp
            self.load_UserExps(trend_new,ident: 0)
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    //get experiences
    func get_experiences(eid:String,ident:Int){
        accountRef = myRootRef.childByAppendingPath("data/experiences/\(eid)")
        accountRef.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.value)
            if(String(snapshot.value) != "<null>"){
                let exp = ExperienceData()
                exp.setExpId_(eid)
                exp.setExpName_(snapshot.value.objectForKey("expname") as! String)
                exp.setExpDesc_(snapshot.value.objectForKey("expdesc") as! String)
                exp.setExpLocation_(snapshot.value.objectForKey("explocation") as! String)
                exp.setDate_(snapshot.value.objectForKey("expdate") as! String)
                exp.setAS_(snapshot.value.objectForKey("expavailableslots") as! String)
                exp.setExpPrice_(snapshot.value.objectForKey("expprice") as! String)

                if let lat = snapshot.value.objectForKey("lat") as? Double {
                    if let lon = snapshot.value.objectForKey("lon") as? Double{
                        exp.setLocation2(lat,lon: lon)
                    }
                }
                self.expPicRef = self.expPicRef.childByAppendingPath("/\(eid)")
                self.dloadexpPic(exp,ident: ident)

            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        accountRef = myRootRef.childByAppendingPath("data/experiences/")
        
    }
    
    func get_eid(search_location:String){
        self.exps = []
        accountRef = myRootRef.childByAppendingPath("data/locations/\(search_location)")
        accountRef.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.description)
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                self.get_experiences(rest.key as String,ident: 0)
                print(rest.key)
            }
            print(self.exps.count)
            self.tableView.reloadData()
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        accountRef = myRootRef.childByAppendingPath("data/locations/")
        
    }
    
    //get current user exp info
    func load_exps(){
        hosted_exp = [String]()
        reg_exp = [String]()
        exps_host = [ExperienceData]()
        exps_reg = [ExperienceData]()
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
        user_exp = user_exp.childByAppendingPath("exp_host")
        user_exp.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.description)
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                //print(rest.key)
                self.hosted_exp.append(String(rest.key))
            }
            self.load_UserExps(self.hosted_exp,ident: 1)
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
            self.load_UserExps(self.reg_exp,ident: 2)
            }, withCancelBlock: { error in
                print(error.description)
        })
        user_exp = myRootRef.childByAppendingPath("data/users/\(self.user)")
        
    }
    
    //load exps
    func load_UserExps(exps_loc:[String],ident:Int){
        for exp in exps_loc{
            self.get_experiences(exp as String,ident:ident)
        }
    }
    
    // MARK: Location
    
    //save locally the current location
    func saveLocation(location:CLLocation){
        
        let lat = NSNumber(double: location.coordinate.latitude)
        let lon = NSNumber(double: location.coordinate.longitude)
        let userLocation: NSDictionary = ["lat": lat, "long": lon]
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userLocation, forKey: "localLocation_cord")
        defaults.setObject(self.city, forKey: "localLocation_name")
    }
    
    //retrive location stored in the app
    func retriveLocation()->CLLocation{
        let defaults = NSUserDefaults.standardUserDefaults()
        // get the current high score
        let userLocation = defaults.objectForKey("localLocation_cord" ) //as! NSDictionary
        
        let userLocation_name = defaults.objectForKey("localLocation_name" ) //as! NSDictionary
        if userLocation_name != nil{
            self.city = userLocation_name as! String
            self.location.text = self.city
        }
        if userLocation != nil{
            let locallocation = userLocation as! NSDictionary
            let location = CLLocation(latitude: CLLocationDegrees(locallocation["lat"] as! NSNumber ), longitude: CLLocationDegrees(locallocation["long"] as! NSNumber))
            return location
        }
        return CLLocation(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0))
        
    }
    
    //retrive location Name
    func getLocation_name(lat:Double,long:Double){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long as CLLocationDegrees)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.city_search = city as String

                print(city)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                self.city_search += country as String
                print(country)
            }
            
            self.get_eid(self.city_search)
            
        })
    }
    
    // MARK: Auto-fill place Google places protocol methods
    
    //Location TextField toucled
    @IBAction func locationTouched(sender: UITextField) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.presentViewController(autocompleteController, animated: true, completion: nil)
    }
    
    //when the new loaction is selected
    func updateautofill(place:GMSPlace){
        
        let name = place.name as String
        let formattedAddress = place.formattedAddress! as String
        var our_place :String
        if formattedAddress.rangeOfString(name) != nil{
            our_place = formattedAddress
        }
        else{
            our_place = name + ", " + formattedAddress
        }
        location_coord = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.update_Place(our_place,coordinates: location_coord)
        self.saveLocation(CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
    }
    
    //Method that gets the location from GP ViewController
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        print("Place name: ", place.name)
        updateautofill(place)
        print("Place co-ordinate: (\(place.coordinate.latitude),\(place.coordinate.longitude))")
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //when nothing is selected
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        print("Error: ", error.description)
    }
    
    //when user cancles the location update screen
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Auto predict is aways true
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    //when the auto complete prediction is changable
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //place is updated thru Google places search
    func update_Place(place:String,coordinates:CLLocation){
        self.city = place
        self.location.text = self.city
        self.saveLocation(coordinates)
        self.getLocation_name(coordinates.coordinate.latitude,long: coordinates.coordinate.longitude)
    }
    
    //download exp image and set
    func dloadexpPic(exp:ExperienceData,ident:Int){
        //print(expPicRef.description)
        expPicRef.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.value)
            if(String(snapshot.value) != "<null>"){
                let decodedData = NSData(base64EncodedString: snapshot.value as! String , options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                
                let decodedImage = UIImage(data: decodedData!)
                
                exp.setImgage_(decodedImage!)
                if(ident == 0){
                    self.exps.append(exp)
                }else if(ident == 1){ //host
                    self.exps_host.append(exp)
                }else{
                    self.exps_reg.append(exp)
                }
                //print("Hit")
                self.tableView.reloadData()
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        expPicRef = myRootRef.childByAppendingPath("data/exp_pics/")
    }
    
    // MARK: Navigation
    
    //prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let descriptivepage = segue.destinationViewController as! ExperienceDescVC
        let indexPath = self.tableView.indexPathForSelectedRow!
        var buss = ExperienceData()
        if(mode == 0 || mode == 1||mode == 3){
            buss = exps[indexPath.row]
        }else{
            if(indexPath.section == 0){
                buss = exps_host[indexPath.row]
            }else{
                buss = exps_reg[indexPath.row]
            }
        }
        descriptivepage.expData = buss
        descriptivepage.hidesBottomBarWhenPushed = true
    }
    

}
