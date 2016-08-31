////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomePrimaryVC.swift                                           //
//  Created by Sai Krishna Bandaru on 4/9/16.                     //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////


import UIKit
//imports for Facebook, Firebase and Google places kits
import Foundation
import GoogleMaps
import FBSDKLoginKit
import Firebase

//The main homescreen of the app
class HomePrimaryVC: UIViewController, UITableViewDataSource,UITableViewDelegate,GMSAutocompleteViewControllerDelegate {
    
    //To capture Yelp data
    var businesses: [Business]!
    
    //text field handle to capture search location
    @IBOutlet weak var location: UITextField!
    
    
    //Firebase root handle and Userinfo handle
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var userHandle = Firebase(url:"https://explore-app.firebaseio.com")
    
    //tableview handle for delagation and reload info
    @IBOutlet weak var locationsTableView: UITableView!
    
    //location manager instance to retrieve user location
    var coreLocationManager : CLLocationManager!
    
    //gogle places instance handle to retrieve user location
    var placesClient: GMSPlacesClient?
    
    //
    var city = ""
    
    // MARK: ViewController methods
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        placesClient = GMSPlacesClient()
        getCurrentLocation()
        super.viewDidLoad()
        locationsTableView.delegate = self
        let color_obj = Colors()
        self.location.textColor =  color_obj.UIColorFromRGB(0x1C8D47)
    }
    
    //didReceiveMemoryWarning
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Utility Methods
    
    //get location from the UItext field
    func getLocation()->String{
        
        if location != nil{
            return location.text!
        }
        else{
            return "New York City"
        }
    }
    
    //get type the UItext field
    func getType()->String{
        
        return "Monuments"
    }
    
    //get sort the UItext field
    func getSort()->YelpSortMode{
        
        return YelpSortMode.HighestRated
    }
    
    
    
    //download info from Yelp with location and update tableview
    func downloadUpdate(){
        
        let location = getLocation()
        let type = getType()
        let sort = getSort()
        print("Search criteria: Location: \(location)  Type: \(type)  Sort: \(sort)")
        Business.searchWithTerm(location,term:type,sort:sort, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if (businesses != nil){
                
                self.businesses = businesses
                self.locationsTableView.reloadData()
            }
        })
        
    }
    
    // MARK: TableView DataSource Protocols
    
    //number of sections method
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return 1
    }
    
    //number of rows on each section method
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.businesses != nil) ? businesses.count : 1;
    }
    
    //cell in each section method
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(self.businesses != nil){
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomCell
            //cell.backgroundColor = UIColor.lightGrayColor()
            cell.layer.borderWidth = 0.5
            let l_gray = UIColor.lightGrayColor()
            cell.layer.borderColor = l_gray.CGColor
            cell.place.text = (self.businesses[indexPath.row].name != nil) ?self.businesses[indexPath.row].name!:"Not given"
            cell.address.text = (self.businesses[indexPath.row].address != nil) ?self.businesses[indexPath.row].address!:"Not given"
            cell.categories.text = (self.businesses[indexPath.row].categories != nil) ?String(self.businesses[indexPath.row].categories!):"Not given"
            let imageURL =  (self.businesses[indexPath.row].imageURL != nil) ? String(self.businesses[indexPath.row].imageURL!) :"http://upload.wikimedia.org/wikipedia/en/4/43/Apple_Swift_Logo.png"
            ImageLoader.sharedLoader.imageForUrl(imageURL , completionHandler:{(image: UIImage?, url: String) in
                cell.displayImage.image = image
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                //cell.displayImage.layer.borderWidth = 2.0
                cell.displayImage.layer.cornerRadius = 5;
                cell.displayImage.clipsToBounds = true;
            })
            return cell;
        }
        else{
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Data for your search"
            return cell
        }
    }
    
    //deselect tableview once selection is one
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: Utility methods 2
    
    //populate current location in location text field
    func getCurrentLocation(){
        
        placesClient?.currentPlaceWithCallback({
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    let completeAddr = place.formattedAddress!.componentsSeparatedByString(",")
                        .joinWithSeparator(",")
                    // MARK: Change1
                    self.update_Place(self.addres_trim(completeAddr),coordinates: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
                    //self.location.text = self.addres_trim(completeAddr)
                    self.downloadUpdate()

                }
            }
        })
        
    }
    
    //method to trim the address to suit the search
    func addres_trim(address:String)->String{
       
        var address_ = address.characters.split(",").map(String.init)
        let firstName: String = address_.count > 1 ? address_[1] : ""
        let lastName: String = address_.count > 2 ? address_[2] : ""
        return "\(firstName) \(lastName)"
    }
    
    // MARK: Navigation Method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let descriptivepage = segue.destinationViewController as! LocationDescVC
        let indexPath = self.locationsTableView.indexPathForSelectedRow!
        let buss = self.businesses[indexPath.row]
        descriptivepage.businesses = buss
        descriptivepage.hidesBottomBarWhenPushed = true
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
        
        self.update_Place(our_place,coordinates: CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        self.downloadUpdate()
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

    // MARK: Dummy delete methods
    
    //load the Home Screen if user has already signed in
    func loadHomeAfterSignIn(){
        
        let nextViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("DescriptiveViewController"))! as UIViewController
        let appDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        appDelegate.window?.rootViewController = nextViewController
        
    }
    
    //////Facebook
    func updateFBuserinFire(){
        if(FBSDKAccessToken.currentAccessToken()==nil){
            print(FBSDKAccessToken.currentAccessToken())
            userHandle = myRootRef.childByAppendingPath("data/users/\(FBSDKAccessToken.currentAccessToken())")
            userHandle.observeEventType(.Value, withBlock: { snapshot in
                print(snapshot)
                if(snapshot == nil){
                    self.userHandle = self.myRootRef.childByAppendingPath("data/users/")
                    self.insertUserInCloud("\(FBSDKAccessToken.currentAccessToken())",email:"\(FBSDKAccessToken.currentAccessToken())@explore.com")
                    self.userHandle = self.myRootRef.childByAppendingPath("data/users/\(FBSDKAccessToken.currentAccessToken())")
                    self.constructProfile()
                }
                
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }
    }
    
    func insertUserInCloud(uid:String,email:String){
        let emailVal = ["email_exp":email]
        let insertVal = [uid:emailVal]
        self.userHandle.updateChildValues(insertVal)
        
    }
    
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
    
    
    /////////////////////////////////////////////////////////////////
    //Location                                                     //
    /////////////////////////////////////////////////////////////////
    func initLocation(){
        coreLocationManager = CLLocationManager()
        //coreLocationManager.delegate=self
        //locationManager = LocationManager.sharedInstance
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        coreLocationManager.requestAlwaysAuthorization()
        coreLocationManager.startUpdatingLocation()
        let authorizationCode = CLLocationManager.authorizationStatus()
        if (authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector("requestAlwaysAuthorization") && coreLocationManager.respondsToSelector("requestWhenInUseAuthorization")){
            if( NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil){
                coreLocationManager.requestAlwaysAuthorization()
                print("no permissions")
            }
            else{
                print("No User Text embeded")
            }
        }else{
            if( self.coreLocationManager.location != nil){
                saveLocation(self.coreLocationManager.location! )
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if( self.coreLocationManager.location != nil){
            saveLocation(self.coreLocationManager.location! )
        }
        
    }
    
    //when permissions or the location has changed
    func locationManager(manager:CLLocationManager!,didChangeAuthrizationStatus status:CLAuthorizationStatus){
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted{
            if( self.coreLocationManager.location != nil){
                saveLocation(self.coreLocationManager.location! )
            }
        }
        
    }
    
    //Loads Location name when the co-ordinates are given
    func loadLocation(){
        let location = self.retriveLocation()
        self.location.text = "Default Location"
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print("for laod name \(location)")
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                print("place marker\(pm)")
                self.location.text = pm.locality!
                //self.downloadUpdate()
                print(pm.locality)
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    //for updating location lable with current location
    func upDateLocationLable(){
        loadLocation()
    }
    
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
        if userLocation != nil{
            let locallocation = userLocation as! NSDictionary
            let location = CLLocation(latitude: CLLocationDegrees(locallocation["lat"] as! NSNumber ), longitude: CLLocationDegrees(locallocation["long"] as! NSNumber))
            return location
        }
        return CLLocation(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0))
        
    }
    
    //place is updated thru Google places search
    func update_Place(place:String,coordinates:CLLocation){
        self.city = place
        self.location.text = self.city
        self.saveLocation(coordinates)
    }

}