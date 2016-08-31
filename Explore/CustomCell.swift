////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Sai Krishna         on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var place: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var categories: UILabel!
    
    @IBOutlet weak var displayImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
