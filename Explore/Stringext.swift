//
//  Stringext.swift
//  Explore
//
//  Created by Sai Krishna Bandaru on 4/20/16.
//  Copyright © 2016 Sai Krishna. All rights reserved.
//

import UIKit


extension String
{
    var parseJSONString: AnyObject?
        {
            let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            if let jsonData = data
            {
                // Will return an object or nil if JSON decoding fails
                do
                {
                    let message = try NSJSONSerialization.JSONObjectWithData(jsonData, options:.MutableContainers)
                    if let jsonResult = message as? NSMutableArray
                    {
                        print(jsonResult)
                        
                        return jsonResult //Will return the json array output
                    }
                    else
                    {
                        return nil
                    }
                }
                catch let error as NSError
                {
                    print("An error occurred: \(error)")
                    return nil
                }
            }
            else
            {
                // Lossless conversion of the string was not possible
                return nil
            }
    }
}
