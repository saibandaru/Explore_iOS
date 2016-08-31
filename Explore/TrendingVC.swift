////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Pavan Kumar         on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit

class TrendingVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewExpScreen()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadViewExpScreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //load the Home Screen if user has already signed in
    func loadViewExpScreen(){
        
        let nav  = self.storyboard!.instantiateViewControllerWithIdentifier("ExperiencesVC") as! ExperiencesVC
        nav.mode = 3
        if let navigation = self.navigationController{
            navigation.pushViewController(nav, animated: false)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */


}
