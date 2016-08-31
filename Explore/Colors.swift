////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur        on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit

class Colors: NSObject {
    var bgColor = UIColor.whiteColor()

    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func assignDefaultMaster(){
        bgColor = UIColor.lightGrayColor()
    }
    func assignDefault(){
       bgColor = UIColorFromRGB(0x0F8B35)
    }
    func assignDefault_(){
        bgColor = UIColorFromRGB(0x008000)
    }
    func assignDefault__(){
        bgColor = UIColorFromRGB(0x006400)
    }/*0F8B35
    #008000
    #006400
*/

}
