//
//  GetDirection.swift
//  Map
//
//  Created by Mohamed Kamal on 19/04/2022.
//  Reference : https://www.youtube.com/watch?v=xdzKleTt5QA&list=PLQaOY10EEc8bNbEBMyiJU1I-GIgs1LQfj&index=94
import Foundation
import UIKit
import MapKit
class GetDirectionVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getDirectionView: UIButton!
    var locationManager = CLLocationManager()
    var routes: [MKOverlay] = []
    var endLocation: CLLocationCoordinate2D?
    let pin = MKPointAnnotation()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if endLocation != nil{
            mapView.removeAnnotation(pin)
        }
        if routes.count > 0 {
            mapView.removeOverlays(routes)
            routes.removeAll()
        }
        let touch = touches.first!
        let location = touch.location(in: self.view)
        endLocation = self.mapView.convert(location, toCoordinateFrom:self.mapView)
        guard let location = endLocation else {return}
        setAnnotation(location: location)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if isLocationServiceEnable(){
            checkAuthorization()
        }
        else{
            showAlert(message: "Please authorize access to your location")
        }
    }
    //MARK: - set annotation
    private func setAnnotation(location: CLLocationCoordinate2D){
        pin.coordinate = location
        mapView.addAnnotation(pin)
    }
    //MARK: - chek is location service enable
    private func isLocationServiceEnable() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    //MARK: - check authorization
    private func checkAuthorization(){
        switch locationManager.authorizationStatus{
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlert(message: "Please authorize access to your location")
            break
        case .restricted:
            showAlert(message: "Authorization restricted")
            break
        default:
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
        if message != "Select Region First!"{
            alert.addAction(alertActionSetting)
        }
        present(alert,animated: true)
    }
    //MARK: - set region
    private func setStartRegion(location: CLLocation, distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    @IBAction func getDirectionTapped(_ sender: Any) {
        if let location = locationManager.location, let endLocation = endLocation{
            drawDirection(startLocation: location.coordinate, endLocation: endLocation)
        }
        else{
            showAlert(message: "Select Region First!")
        }
    }
    //MARK: - draw direction
    private func drawDirection(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){
        let startLocationPlace = MKPlacemark(coordinate: startLocation)
        let endLocationPlace = MKPlacemark(coordinate: endLocation)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocationPlace)
        request.destination = MKMapItem(placemark: endLocationPlace)
        request.transportType = .automobile
        //request.requestsAlternateRoutes = true
        let direction = MKDirections(request: request)
        direction.calculate { response, error in
            guard let response = response else {
                if let error = error{
                    print(error.localizedDescription)
                }
                return
            }
            for route in response.routes{
                self.mapView.addOverlay(route.polyline) // to add line (direction)
                self.routes.append(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true) // to focus on all region to see complete region
            }
        }
    }

    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension GetDirectionVC: CLLocationManagerDelegate, MKMapViewDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        setStartRegion(location: location, distance: 1000)
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:    // user allow access to his location during using application only
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:       // user allow access to his location always
            locationManager.startUpdatingLocation()
            break
        case .denied:                 // user not allow access to his location
            showAlert(message: "Please authorize access to your location")
            break
        default:
            print("default ..")
            break
        }
    }
    
    // -------------------
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        render.lineWidth = 2
        return render
    }
    
    //---------------------



}

