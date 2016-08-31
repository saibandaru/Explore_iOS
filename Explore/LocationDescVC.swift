////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  LocationDescVC.swift                                          //
//  Created by Ajith Kallur  on 4/14/16.                          //
//  Copyright © 2016. All rights reserved.                        //
////////////////////////////////////////////////////////////////////


import UIKit
import CoreLocation
import Foundation

//Screen to describe the location
class LocationDescVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    //to capture the location information sent by previous sague
    var businesses: Business!
    
    //tableview handle for delegation and reload data source purpose
    @IBOutlet weak var tableView: UITableView!

    //table view section headers info
    let arr = ["","Name","Address","Distance","Categories","Rating","Opened/Cloised","More"]
    
    //no of sections in tableview
    let sections = 8
    
    // MARK: ViewController Methods
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "About Place"
        tableView.delegate = self
    }
    
    //didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TableView protocol methods
    
    //no of sections in TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sections;
    }
    
    //no of rwosin each section of TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section < 7){
            return 1
        }else{
            return 2
        }
    }
    
    //cell content for each row of tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell :UITableViewCell
        if(indexPath.section==0){
            let cell_=tableView.dequeueReusableCellWithIdentifier("Desp_cell1",forIndexPath:indexPath) as! Desp_cell1
            let imageURL =  (self.businesses.imageURL != nil) ? String(self.businesses.imageURL!) :"http://upload.wikimedia.org/wikipedia/en/4/43/Apple_Swift_Logo.png"
            let new_imageURL = self.sunstring_image(imageURL)
            ImageLoader.sharedLoader.imageForUrl(new_imageURL , completionHandler:{(image: UIImage?, url: String) in
                cell_.image_.image  = image
                cell_.image_.contentMode = .ScaleAspectFill
            })
            return cell_
        }
        else if(indexPath.section==1){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            
            cell.textLabel?.text = (self.businesses.name != nil) ?self.businesses.name!:"Not given";
        }
        else if(indexPath.section==2)
        {
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text =  (self.businesses.display_address != nil) ?self.businesses.display_address!:"Not given"
        }
        else if(indexPath.section==3){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text = getDistance(self.businesses.lat!,long: self.businesses.long!)+" miles"
        }
        else if(indexPath.section==4){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text = (self.businesses.categories != nil) ?self.businesses.categories!:"Not given"
        }
        else if(indexPath.section==5){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            cell.textLabel?.text =  "5"
        }
        else if(indexPath.section==6){
            cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
            let isClosed = (self.businesses.isClosed != nil) ? self.businesses.isClosed! : true
            let isClosed_str = isClosed ? "Closed" : "Open"
            cell.textLabel?.text = isClosed_str
        }
        else if(indexPath.section==7){
            if(indexPath.row == 1){
                let cell_ = tableView.dequeueReusableCellWithIdentifier("Desp_cell3",forIndexPath:indexPath) as! AddExpCell
                //let tap_s = UITapGestureRecognizer(target: self, action: #selector(LocationDescVC.(_:)))
                let tap_s = UITapGestureRecognizer(target: self, action: Selector("addExpHandle:"))
                tap_s.numberOfTapsRequired = 1
                cell_.addExpButton.addGestureRecognizer(tap_s)
                return cell_
            }else{
                let color_obj = Colors()
                cell=tableView.dequeueReusableCellWithIdentifier("Desp_cell2",forIndexPath:indexPath) as UITableViewCell
                cell.textLabel?.text = "View Hosted Experiences"
                cell.textLabel?.textColor = color_obj.UIColorFromRGB(0x1C8D47)
                cell.textLabel?.textAlignment = NSTextAlignment.Center
               // let tap_s = UITapGestureRecognizer(target: self, action: #selector(LocationDescVC.viewExpHandle(_:)))
                let tap_s = UITapGestureRecognizer(target: self, action: Selector("viewExpHandle:"))
                tap_s.numberOfTapsRequired = 1
                cell.addGestureRecognizer(tap_s)
                return cell
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
        }
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
        
        if(section < 8){
            return arr[section]
        }
        return "default";
    }
    
    //deselect tableview once selection is one
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: Utility methods
    
    //to calculate distance between two points
    func findDistanceBtwnTwoPoints(from: CLLocation, to: CLLocation)->String{
        
        return String(roundToPlaces(0.621371*(from.distanceFromLocation(to)/1000),places: 2))
    }
    
    //distance when a point is given
    func getDistance(lat : NSNumber,long: NSNumber )->String{
        
        return findDistanceBtwnTwoPoints(self.retriveLocation(),to: CLLocation(latitude: lat as Double, longitude:long as Double))
    }
    
    //retrive location stored in the app
    func retriveLocation()->CLLocation{
        
        let defaults = NSUserDefaults.standardUserDefaults()
        // get the current high score
        let userLocation = defaults.objectForKey("localLocation" ) //as! NSDictionary
        if userLocation != nil{
            let locallocation = userLocation as! NSDictionary
            let location = CLLocation(latitude: CLLocationDegrees(locallocation["lat"] as! NSNumber ), longitude: CLLocationDegrees(locallocation["long"] as! NSNumber))
            return location
        }
        return CLLocation(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0))
    }
    
    //rounding of double of double
    func roundToPlaces(value:Double, places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    //create new URL for high quality image from Yelp
    func sunstring_image(URLImage_:String)->String{
        let newstr = URLImage_.substringWithRange(Range<String.Index>(start: URLImage_.startIndex.advancedBy(0), end: URLImage_.endIndex.advancedBy(-6)))
        let newURL = "\(newstr)l.jpg"
        return newURL
        
    }
    
    //to handle add experience sague
    func addExpHandle(sender: UITapGestureRecognizer) {
        print("Add Exp Clicked")
        self.loadAddExpScreen()
    }
    
    //to handle view experience sague
    func viewExpHandle(sender: UITapGestureRecognizer) {
        print("View Exp Clicked")
        self.loadViewExpScreen()
    }
    /* yelp image resolution and extensions
    s.jpg: up to 40×40
    ss.jpg: 40×40 square
    m.jpg: up to 100×100
    ms.jpg: 100×100 square
    l.jpg: up to 600×400
    ls.jpg: 250×250 square
    o.jpg: up to 1000×1000
    348s.jpg: 348×348 square
    */
    
    // MARK: Navigation functions
    
    //load Add Experience sague
    //load the Home Screen if user has already signed in
    func loadAddExpScreen(){
        
        let nav  = self.storyboard!.instantiateViewControllerWithIdentifier("CreateExpScreen1") as! CreateExperienceScreen1
        //self.navigationController?.presentViewController(nav, animated: true, completion: nil)
        nav.businesses = self.businesses
        nav.mode = 0

        if let navigation = self.navigationController{
            print("exists")
            navigation.pushViewController(nav, animated: true)
            
        }
        //performSegueWithIdentifier("CreateExperience", sender: self)
    }
    
    //load the Home Screen if user has already signed in
    func loadViewExpScreen(){
        
        let nav  = self.storyboard!.instantiateViewControllerWithIdentifier("ExperiencesVC") as! ExperiencesVC
        //self.navigationController?.presentViewController(nav, animated: true, completion: nil)
        nav.mode = 1
        nav.city_search = self.businesses.id!
        nav.place = self.businesses.name!
        if let navigation = self.navigationController{
            print("exists")
            navigation.pushViewController(nav, animated: true)
            
        }
        //performSegueWithIdentifier("CreateExperience", sender: self)
    }
}