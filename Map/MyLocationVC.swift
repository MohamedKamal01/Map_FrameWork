//
//  MyLocationVC.swift
//  Map
//
//  Created by Mohamed Kamal on 17/04/2022.
//
// https://www.youtube.com/watch?v=4hNVUDDfE98&list=PLQaOY10EEc8bNbEBMyiJU1I-GIgs1LQfj&index=91
import UIKit
import MapKit
import CoreLocation
class MyLocationVC: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // to accuracy of location
        locationManager.allowsBackgroundLocationUpdates = true // to update location in background
        if isLocationServiceEnable(){
            checkAuthorization()
        }
        else{
            showAlert(message: "Please enable location service")
        }
    }
    //MARK: - is location service enable
    private func isLocationServiceEnable() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    //MARK: - Check if the user has allowed access to their location or not
    private func checkAuthorization(){
        switch locationManager.authorizationStatus{
        case .notDetermined:          // user not use appliation
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:    // user allow access to his location during using application only
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .authorizedAlways:       // user allow access to his location always
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .denied:                 // user not allow access to his location
            showAlert(message: "Please authorize access to your location")
            break
        case .restricted:// user not has control to give permission (for ex: his dad has permission to control with his mobile)
            showAlert(message: "Authorization restricted")
            break
        default:
            print("default ..")
            break
        }
    }
    //MARK: - show alert
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let alertActionSetting = UIAlertAction(title: "Setting", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        alert.addAction(alertAction)
        alert.addAction(alertActionSetting)
        present(alert,animated: true)
    }
    //MARK: - set start region
    private func setStartRegion(location: CLLocation,distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    //MARK: - to dismiss map
    @IBAction func dismissMap(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}
extension MyLocationVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            print("location : \(location.coordinate)")
            setStartRegion(location: location, distance: 1000)
        }
        //locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:    // user allow access to his location during using application only
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .authorizedAlways:       // user allow access to his location always
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            break
        case .denied:                 // user not allow access to his location
            showAlert(message: "Please authorize access to your location")
            break
        default:
            print("default ..")
            break
        }
    }
}
