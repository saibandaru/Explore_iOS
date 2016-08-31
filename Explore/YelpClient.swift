////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur        on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////import UIKit
import AFNetworking
import BDBOAuth1Manager


let yelpConsumerKey = "uE15qdbbiEBlmGtt1S7KTQ"
let yelpConsumerSecret = "qnzs3IKBwk3XlwXZgNEEYLopgo8"
let yelpToken = "ukvKRI8BSYh5kZbKEa9gZBvAbUCc3agJ"
let yelpTokenSecret = "xmdNdTzYiUhuuRK6mdvWb15cTgY"

enum YelpSortMode: Int {
    case BestMatched = 0, Distance, HighestRated
}

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    class var sharedInstance : YelpClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : YelpClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        }
        return Static.instance!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        let baseUrl = NSURL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        let token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    //search with term
    func searchWithTerm(term: String, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm("",term:term, sort: nil, categories: nil, deals: nil, completion: completion)
    }
    
    //search with term and categeory
    func searchWithTerm(term: String, cat: [String],completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm("",term:term, sort: nil, categories: cat, deals: nil, completion: completion)
    }
    
    //search with sort and city NYC
    func searchWithTerm(term: String, sort: YelpSortMode?,completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm("",term: term, sort: sort, categories: nil, deals: nil, completion: completion)
    }
    
    //search with location, term and sort
    func searchWithTerm(location:String,term: String, sort: YelpSortMode?,completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        return searchWithTerm(location,term: term, sort: sort, categories: nil, deals: nil, completion: completion)
    }
    
    func searchWithTerm(location:String,term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, completion: ([Business]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        
        // Default the location to San Francisco
        var parameters: [String : AnyObject]
        if(location == ""){
            parameters = ["term": term, "location": "New York City"]
        }
        else{
            parameters = ["term": term, "location": location]
        }
        
        if sort != nil {
            parameters["sort"] = sort!.rawValue
        }
        
        if categories != nil && categories!.count > 0 {
            parameters["category_filter"] = (categories!).joinWithSeparator(",")
        }
        
        if deals != nil {
            parameters["deals_filter"] = deals!
        }
        
        print(parameters)
        
        return self.GET("search", parameters: parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let dictionaries = response["businesses"] as? [NSDictionary]
            if dictionaries != nil {
                completion(Business.businesses(array: dictionaries!), nil)
            }
            }, failure: { (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                completion(nil, error)
        })!
    }
}
