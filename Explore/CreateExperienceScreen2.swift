////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur                                       //
//  Copyright © 2016  All rights reserved.                        //
////////////////////////////////////////////////////////////////////
import Firebase
import FBSDKLoginKit
import CoreLocation
//.........To create user experience......
class CreateExperienceScreen2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var prev_data: NSDictionary!
    
    var businesses: Business!
    
    var prev_data_: NSDictionary!
    
    var user = "user"
    
    var city:String = "city"
    
    var base64String = ""
    
    var location_coord = CLLocation()
    
    var mode = 0


    @IBOutlet weak var expDate: UITextField!
    @IBOutlet weak var expPrice: UITextField!
    @IBOutlet weak var expAvailableSlots: UITextField!
    @IBOutlet weak var expDatePicker: UIDatePicker!
    
    
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var expRef = Firebase(url:"https://explore-app.firebaseio.com")
    var expRef_image = Firebase(url:"https://explore-app.firebaseio.com")
    var expRef_location = Firebase(url:"https://explore-app.firebaseio.com")
    var userRef = Firebase(url:"https://explore-app.firebaseio.com")
    var trendingRef = Firebase(url:"https://explore-app.firebaseio.com")


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "Create Experience"

        //self.view.backgroundColor = UIColor.lightGrayColor()
        
        expDatePicker.addTarget(self, action: Selector("expDatePicked:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.initalizeToExpHome()
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //dismiss keyboard
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //user firebase handle initalization
    func initalizeToExpHome(){
        self.add_boundaries()
        getLatest()
        expRef = myRootRef.childByAppendingPath("data/experiences/")
        expRef_image = myRootRef.childByAppendingPath("data/exp_pics/")
        expRef_location = myRootRef.childByAppendingPath("data/locations/")
        userRef = myRootRef.childByAppendingPath("data/users/")
        trendingRef = myRootRef.childByAppendingPath("data/trending/")
        get_CurrUser()
        if(self.mode == 0){
            self.getLocation(Double(businesses.lat!.doubleValue),long: Double(businesses.long!.doubleValue))
        }
    }
    
    func add_boundaries(){
        let l_gray = UIColor.lightGrayColor()
        expDate.layer.borderColor = l_gray.CGColor
        expDate.layer.borderWidth = 1.0
        expDate.layer.cornerRadius = 5.0

        expPrice.layer.borderColor = l_gray.CGColor
        expPrice.layer.borderWidth = 1.0
        expPrice.layer.cornerRadius = 5.0
        
        expAvailableSlots.layer.borderColor = l_gray.CGColor
        expAvailableSlots.layer.borderWidth = 1.0
        expAvailableSlots.layer.cornerRadius = 5.0
        
    }
   
//.....action to create new experience....
    @IBAction func createExperience(sender: AnyObject) {
        let expDate_ = expDate.text
        let expPrice_ = expPrice.text
        let expAvailableSlots_ = expAvailableSlots.text
        let expid = NSUUID().UUIDString
        //prev_data_ = prev_data;
        if(self.mode == 0){
            let lat = businesses.lat
            let lon = businesses.long
            prev_data_  = ["expdate":expDate_!, "expprice": expPrice_!,"expavailableslots":expAvailableSlots_!,"expname":prev_data["expname"]!,"expdesc":prev_data["expdesc"]!, "explocation":prev_data["explocation"]!,"lat":lat!,"lon":lon!,"host":self.user]

        }else{
        prev_data_  = ["expdate":expDate_!, "expprice": expPrice_!,"expavailableslots":expAvailableSlots_!,"expname":prev_data["expname"]!,"expdesc":prev_data["expdesc"]!, "explocation":prev_data["explocation"]!,"lat":location_coord.coordinate.latitude,"lon":location_coord.coordinate.longitude]
        }
        //prev_data.updateValue("efg", forKey: "")
        
        expRef_image.childByAppendingPath(expid).setValue(base64String)
        expRef.childByAppendingPath(expid).setValue(prev_data_)
        expRef = myRootRef.childByAppendingPath("data/experiences/id")
        expRef.childByAppendingPath(expid).setValue("")
        expRef = myRootRef.childByAppendingPath("data/experiences/")
        expRef_location = expRef_location.childByAppendingPath("/\(self.city)")
        print(expRef_location.description)
        expRef_location.childByAppendingPath(expid).setValue("")
        expRef_location = myRootRef.childByAppendingPath("data/locations/")
        if(self.mode == 0){
            expRef_location = expRef_location.childByAppendingPath("/\(self.businesses.id!)")
            print(self.businesses.id)
            expRef_location.childByAppendingPath(expid).setValue("")
            expRef_location = myRootRef.childByAppendingPath("data/locations/")
        }
        userRef = userRef.childByAppendingPath("/\(self.user)/exp_host")
        userRef.childByAppendingPath(expid).setValue("")
        userRef = myRootRef.childByAppendingPath("data/users/")
        self.updateLatest(expid)
        self.navigateBack()
    }
    
    
    func expDatePicked(datePicker:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let strDate = dateFormatter.stringFromDate(expDatePicker.date)
        expDate.text = strDate
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
    //to get loation
    func getLocation(lat:Double,long:Double){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: long as CLLocationDegrees)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.city = city as String
                print(city)
            }
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                self.city += country as String
                print(country)
            }
            
        })
    }
    
    func navigateBack(){
        var viewControllers = self.navigationController?.viewControllers
        viewControllers?.removeLast()
        viewControllers?.removeLast()
        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    var trending_exp = [String]()
    // to display trending experience
    
    func getLatest(){
        trending_exp = [String]()
        trendingRef = myRootRef.childByAppendingPath("data/trending/")
        trendingRef.observeEventType(.Value, withBlock: { snapshot in
            for rest in snapshot.children.allObjects as! [FDataSnapshot] {
                print("\(rest.key)  \(rest.value)")
                self.trending_exp.append(String(rest.value))
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
// update latest experience
    func updateLatest(expID:String){
        var i = 0
        if(self.trending_exp.count > 19){
            i = 19
        }else{
             i = self.trending_exp.count
        }
        while(i > 0){
            self.trendingRef.childByAppendingPath(String(i)).setValue(self.trending_exp[i-1])
            i -= 1;
        }
        self.trendingRef.childByAppendingPath(String(0)).setValue(expID)
        trending_exp = [String]()

    }
    
    


}





