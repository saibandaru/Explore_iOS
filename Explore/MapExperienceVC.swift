////////////////////////////////////////////////////////////////////
//  Explore                                                       //
//  This is an application to bridge tourists and local hosts     //
//  developed for i phones                                        //
//  HomeViewController.swift                                      //
//  Created by Ajith Kallur        on 4/11/16.                    //
//  Copyright © 2016                      All rights reserved.    //
////////////////////////////////////////////////////////////////////

import UIKit
import MapKit
import CoreLocation

class MapExperienceVC: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location = CLLocation()
    
    //viewDidLoad method
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title  = "Location of Experience"
        self.loadMapView()
        
        // Do any additional setup after loading the view.
    }
    
    //didReceiveMemoryWarning method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loadDirections(sender: UIButton) {
        print("\(location.coordinate.latitude)  \(location.coordinate.longitude)")
        let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "Destination Location"
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeDriving : MKLaunchOptionsDirectionsModeKey])
        print("Get Directions")
    }
    
    //point location
    func loadMapView(){
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }

}
