////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur        on 4/11/16.                    //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////


import Firebase
import CoreLocation


class CreateExperienceScreen1: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    var id: String!
    
    var location_coord = CLLocation()
    
    @IBOutlet weak var expName: UITextField!
    
    @IBOutlet weak var expDesc: UITextView!
    
    @IBOutlet weak var expLocation: UITextField!
    
    @IBOutlet weak var photoview: UIImageView!
        
    
    var prev_data: NSDictionary!

    var businesses: Business!

    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var image:UIImage!
    
    var mode = 0
    
    var location = ""
    
    var base64String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title   = "Create Experience"

        self.image = UIImage(named: "bg_home")
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.add_boundaries()
        self.set_modeProperties()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //dismiss keyboard
    func dismissKeyboard(sender: AnyObject) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //add borders
    func add_boundaries(){
        let l_gray = UIColor.lightGrayColor()
        expName.layer.borderColor = l_gray.CGColor
        expName.layer.borderWidth = 1.0
        expName.layer.cornerRadius = 5.0
        
        expDesc.layer.borderColor = l_gray.CGColor
        expDesc.layer.borderWidth = 1.0
        expDesc.layer.cornerRadius = 5.0
        
        expLocation.layer.borderColor = l_gray.CGColor
        expLocation.layer.borderWidth = 1.0
        expLocation.layer.cornerRadius = 5.0
        
    }
    
    func set_modeProperties(){
        if(self.mode == 0){
            expLocation.text = businesses.display_address
            expLocation.userInteractionEnabled = false

        }else{
            expLocation.text = location
        }
    }
    
    


    func populate_user() {
        let expName_ = expName.text
        let expDesc_ = expDesc.text
        let expLocation_ = expLocation.text
        
        var data: NSData = NSData()
        
        if let image = photoview.image {
            data = UIImageJPEGRepresentation(image,0.1)!
        }
        
        self.base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        prev_data = ["expname":expName_!,"expdesc":expDesc_, "explocation":expLocation_!]
    }
    
    
    @IBAction func browseImages(sender: UIButton) {
        print("Hahah")

        self.get_newImage()

    }
    
    @IBAction func browse(sender: UIButton) {
        print("hehe")

        self.get_newImage()

    }


    
    func get_newImage(){
        print("Hahah")
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
   // open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    // open gallery
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Navigation Method
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.populate_user()
        let descriptivepage = segue.destinationViewController as! CreateExperienceScreen2
        descriptivepage.base64String = self.base64String
        descriptivepage.mode = self.mode
        descriptivepage.prev_data = self.prev_data
        if(self.mode == 0 ){
            descriptivepage.businesses = self.businesses
        }else{
            descriptivepage.city = self.location
            descriptivepage.location_coord = self.location_coord
        }
    }
    // Image picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        photoview.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoview.backgroundColor = UIColor.clearColor()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
