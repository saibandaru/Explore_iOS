////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  DisplayImageVC.swift                                          //
//  Created by Sai Krishna Bandaru on 4/14/16.                    //
//  Copyright © 2016 Sai Krishna Bandaru. All rights reserved.    //
////////////////////////////////////////////////////////////////////



import UIKit
import Firebase
import FBSDKLoginKit

class DisplayImageVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var image: UIImageView!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    let myRootRef = Firebase(url:"https://explore-app.firebaseio.com")
    var imageRef = Firebase(url:"https://explore-app.firebaseio.com")
    var imageRefDload = Firebase(url:"https://explore-app.firebaseio.com")
    
    var userToken = ""
    
    var profile_pic : UIImage!
    
    // MARK: ViewController Methods
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        self.title = "Profile Picture"
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "get_newImage")
        image.image = profile_pic
        self.initalizeToUser()
        // Do any additional setup after loading the view.
    }

    //didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Utility Methods
    
    //initalize handle
    //get Facebook or Firebase user Token
    func getToken(){
        if(myRootRef.authData != nil || FBSDKAccessToken.currentAccessToken() != nil ){
            if(myRootRef.authData != nil ){
                userToken = myRootRef.authData.uid!
            }else{
                userToken = FBSDKAccessToken.currentAccessToken().userID
            }
        }
    }
    
    //user firebase handle initalization
    func initalizeToUser(){
        getToken()
        if(userToken != ""){
            imageRef = myRootRef.childByAppendingPath("data/profilepics/")
            imageRefDload = myRootRef.childByAppendingPath("data/profilepics/\(userToken)")
            //print(imageRef.description)
        }
    }
    
    
    func get_newImage(){
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
    //.....To open camera...........
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
    //.............To open gallery......
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //upload image to Firebase
    func uploadImge(image_:UIImage){
        
        var data: NSData = NSData()
        data = UIImageJPEGRepresentation(image_,0.1)!

        
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let imageSet = [ (userToken) : (base64String) as AnyObject]
        self.imageRef.updateChildValues(imageSet)
        //self.navigationController?.popToRootViewControllerAnimated(true)

        
    }
    
    // MARK: Image picker protocols
    
    //open gallery
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        image.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        image.backgroundColor = UIColor.clearColor()
        uploadImge(image.image!)
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    //cancled with-out selection
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //download profileimage and set
    func dloadpp()->UIImage?{
        var image_:UIImage?
        imageRefDload.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.value)
            if(String(snapshot.value) != "<null>"){
                let decodedData = NSData(base64EncodedString: snapshot.value as! String , options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                
                let decodedImage = UIImage(data: decodedData!)
                self.image.image =  decodedImage
                image_ = decodedImage
            }
         }, withCancelBlock: { error in
                    print(error.description)
         })
        return image_
    }
    
}
