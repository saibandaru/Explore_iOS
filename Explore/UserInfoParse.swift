////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Sai Krishna Bandaru        on 4/11/16.             //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit

class UserInfoParse: NSObject {
    
    var username:String = "Not Given"
    var mailID:String = "Not Given"
    var mobile:String = "Not Given"
    var status:String = "Not Given"
    
    
    init(dictionary: NSDictionary) {
        if let name_ = dictionary["username"]{
            username = name_ as! String
        }
        if let mailID_ = dictionary["mailID"]{
            mailID = mailID_ as! String
        }
        if let mobile_ = dictionary["mobile"]{
            mobile = mobile_ as! String
        }
        if let status_ = dictionary["status"]{
            status = status_ as! String
        }
    }
    
    func setUsername_(uname:AnyObject?){
        if (uname != nil){
            username = uname as! String
        }
    }
    func setMailId_(mail:AnyObject?){
        if (mail != nil){
            mailID = mail as! String
        }
    }
    func setMobile_(mobile_:AnyObject?){
        if (mobile_ != nil){
            mobile = mobile_ as! String
        }
    }
    func setStatus_(status_:AnyObject?){
        if (status_ != nil){
            status = status_ as! String
        }
    }

}
