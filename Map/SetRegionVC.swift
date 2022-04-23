//
//  ViewController.swift
//  Map
//
//  Created by Mohamed Kamal on 17/04/2022.
//

import UIKit
import MapKit
class SetRegionVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let initloc = CLLocation(latitude: 24.693719, longitude: 46.723596)
        setStartingLocation(location: initloc, distance: 1000)
        
        setAnnotation()
    }
    //MARK: - map start with specific location
    private func setStartingLocation(location: CLLocation, distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        
        //to set limit to camera, user cannot move via map
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        //to set limit to zoom, user cannot zoom in or zoom out
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 30000), animated: true)
    }
    //MARK: - add annotation
    private func setAnnotation(){
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocation(latitude: 24.693719, longitude: 46.723596).coordinate
        pin.title = "My Title"
        pin.subtitle = "My SubTitle"
        mapView.addAnnotation(pin)
    }

    @IBAction func dismissMap(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
