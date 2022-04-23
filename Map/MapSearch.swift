//
//  MapSearch.swift
//  Map
//
//  Created by Mohamed Kamal on 18/04/2022.
//

import UIKit
import MapKit
class MapSearch: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func searchTapped(_ sender: Any) {
        if nameTextField.text != ""{
            searchLocation(nameTextField.text!)
        }
        else{
            showAlert(message: "please enter your destination")
        }
    }
    //MARK: - search with country name
    private func searchLocation(_ name: String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(name) { places, error in
            guard let place = places?.first, error == nil else {
                self.showAlert(message: "no data to display")
                return}
            guard let location = place.location else{return}
            guard let city = place.name else{return}
            guard let countryName = place.country else{return}
            self.setRegion(location: location, distance: 80000)
            self.setAnnotation(location: location, cityName: city, countryName: countryName)
            self.nameTextField.text = ""
        }
    }
    //MARK: - set region
    private func setRegion(location: CLLocation, distance: CLLocationDistance){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
    }
    //MARK: - set annotation
    private func setAnnotation(location: CLLocation, cityName: String, countryName: String){
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        pin.title = cityName
        pin.subtitle = countryName
        mapView.addAnnotation(pin)
    }
    //MARK: - show alert
    private func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        present(alert,animated: true)
    }
    //MARK: - to dismiss map
    @IBAction func dismissMap(_ sender: Any) {
        dismiss(animated: true)
    }

}
