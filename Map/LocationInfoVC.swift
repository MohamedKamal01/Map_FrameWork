//
//  LocationInfoVC.swift
//  Map
//
//  Created by Mohamed Kamal on 18/04/2022.
//

import UIKit
import MapKit
class LocationInfoVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    private var prevLocation: CLLocation? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    //MARK: - get location information
    private func getLocationInfo(location: CLLocation){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { places, error in
            guard let place = places?.first, error == nil else{return}
            print("----------------")
            print(place.name ?? "no name")
            print(place.locality ?? "no locality")
            print(place.location ?? "no location")
            print(place.country ?? "no country")
            print(place.isoCountryCode ?? "no country code")
        }
    }

    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension LocationInfoVC: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        if prevLocation == nil || prevLocation!.distance(from: newLocation) > 100{
            getLocationInfo(location: newLocation)
        }
        
    }
}
