////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur        on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////
import UIKit

class Business: NSObject {
    
    let id: String?
    let name: String?
    let address: String?
    let display_address: String?
    let imageURL: NSURL?
    let rating_imageURL: NSURL?
    let categories: String?
    let distance: String?
    let long:NSNumber?
    let lat:NSNumber?
    let ratingImageURL: NSURL?
    let reviewCount: NSNumber?
    let isClosed: Bool?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        id = dictionary["id"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let rating_imageURLLoc = dictionary["rating_img_url_large"] as? String
        if rating_imageURLLoc != nil {
            rating_imageURL = NSURL(string: rating_imageURLLoc!)!
        } else {
            rating_imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        var dispaddress_loc = ""
        var lat_l = 0.0 as NSNumber
        var long_l = 0.0 as NSNumber
        if location != nil {
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
            let dispaddr = location!["display_address"] as? NSArray
            if dispaddr != nil && dispaddr!.count > 0 {
                for addline in dispaddr!{
                    dispaddress_loc += addline as! String +
                    "\n"
                }
            }
            let coordinate = location!["coordinate"] as? NSDictionary
            if( coordinate != nil){
                let lat_ll = coordinate!["latitude"] as? NSNumber
                if(lat_ll != nil){
                    lat_l = lat_ll!
                }
                let long_ll = coordinate!["longitude"] as? NSNumber
                if(long_ll != nil){
                    long_l = long_ll!
                }
            }
        }
        self.lat = lat_l
        self.long = long_l
        self.address = address
        self.display_address = dispaddress_loc
        //print("display address \(dispaddress_loc)")
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            categories = categoryNames.joinWithSeparator(", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
        isClosed = dictionary["is_closed"] as? Bool

    }
    
    class func businesses(array array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String,cat: [String], completion: ([Business]!, NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term,cat: cat, completion: completion)
    }
    
    class func searchWithTerm(location:String,term: String, sort: YelpSortMode?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(location,term:term, sort: sort, categories: nil, deals: nil, completion: completion)
    }
    
    class func searchWithTerm(location:String,term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> Void {
        YelpClient.sharedInstance.searchWithTerm(location,term:term, sort: sort, categories: categories, deals: deals, completion: completion)
    }
}