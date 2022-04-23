//
//  MapVC.swift
//  Map
//
//  Created by Mohamed Kamal on 17/04/2022.
//

import UIKit

class MapVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func setStartRegion(_ sender: Any) {
        let setRegionObject = SetRegionVC()
        present(setRegionObject, animated: true)
    }
    
    @IBAction func accessUserLocation(_ sender: Any) {
        let myLocationObject = MyLocationVC()
        present(myLocationObject, animated: true)
    }
    @IBAction func searchWithCityName(_ sender: Any) {
        let mapSearchObject = MapSearch()
        present(mapSearchObject, animated: true)
    }
    
    @IBAction func getLocationInfo(_ sender: Any) {
        let locationInfoObject = LocationInfoVC()
        present(locationInfoObject, animated: true)
    }
    @IBAction func getDirectionTapped(_ sender: Any) {
        let getDirectionObject = GetDirectionVC()
        present(getDirectionObject, animated: true)
    }
}
