////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur        on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit
import CoreLocation

class ExperienceData: NSObject {
    var expid:String = ""
    var expname:String = ""
    var expdesc:String = ""
    var explocation:String = ""
    var expprice:String = ""
    var expavailableslots:String = ""
    var expdate:String = ""
    var location = CLLocation()
    var image = UIImage(named: "tom.jpg")
    
    func setExpId_(expid:String){
        
        self.expid = expid
    }
    
    func getExpId_()->String{
        
        return expid
    }
    
    func setExpName_(expname:String){

        self.expname = expname
    }
    
    func getExpName_()->String{
        
        return expname
    }
    
    func setExpDesc_(expdesc:String){
        
        self.expdesc = expdesc
    }
    
    func getExpDesc_()->String{
        
        return expdesc
    }
    
    func setExpLocation_(explocation:String){
        
        self.explocation = explocation
    }
    
    func getExpLocation_()->String{
        
        return explocation
    }
    
    func setExpPrice_(expprice:String){
        
        self.expprice = expprice
    }
    
    func getExpPrice_()->String{
        
        return expprice
    }
    
    func setAS_(expavailableslots:String){
        
        self.expavailableslots = expavailableslots
    }
    
    func getAS_()->String{
        
        return expavailableslots
    }
    
    func setDate_(expdate:String){
        
        self.expdate = expdate
    }
    
    func getDate_()->String{
        
        return expdate
    }
    
    func setImgage_(image:UIImage){
        
        self.image = image
    }
    
    func getImage_()->UIImage{
        
        return self.image!
    }
    
    func setLocation_(location:CLLocation){
        
        self.location = location
    }
    
    func getLocation_()->CLLocation{
        
        return location
    }
    
    func setLocationString(lat:String,lon:String){
        self.location = CLLocation(latitude: (lat as NSString).doubleValue, longitude: (lon as NSString).doubleValue)
    }
    func setLocation2(lat:Double,lon:Double){
        self.location = CLLocation(latitude: lat, longitude: lon)
    }
    
}
