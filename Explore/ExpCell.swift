////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur        on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////
import UIKit

class ExpCell: UITableViewCell {
    
    @IBOutlet weak var lable1: UILabel!
    
    @IBOutlet weak var lable2: UILabel!
    
    @IBOutlet weak var lable3: UILabel!
    
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
