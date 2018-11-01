//
//  ViewController.swift
//  GoogleMapCustomAnnotation
//
//  Created by Jack Wong on 2018/04/27.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    private let currentLocationMakrker = GMSMarker()
    private let locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    private let customMarkerWidth: Int = 50
    private let customMarkerHeight: Int = 70
    
    let previewDemoData = [(title: "Yakiniku", img: #imageLiteral(resourceName: "image1")), (title:"Ramen", img: #imageLiteral(resourceName: "image1"))]
    let myMapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    let textFieldSearch: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder = "Search for a location"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //custom current location
    let buttonMyLocation: UIButton = {
       let btn = UIButton()
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        return btn
    }()
    var restaurantPreview: RestaurantPreviewView = {
        let v = RestaurantPreviewView()
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initGoogleMaps()
        setupLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController {
    private func setupViews(){
        self.title = "Home"
        self.view.backgroundColor = .white
        view.addSubview(myMapView)
        self.view.addSubview(textFieldSearch)
        self.view.addSubview(buttonMyLocation)
        restaurantPreview = RestaurantPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 190))
        
    }
    
    private func restaurantTapped(tag: Int){
        print("Tag \(tag) is tapped ")
    }
    // first clear map pin , get very small distance from randnum , place marker randomly 
    private func showPartyMarkers(lat: Double, long: Double) {
        myMapView.clear()
        for i in 0..<2 {
            let randNum = Double(arc4random_uniform(30))/10000
            let marker = GMSMarker()
            let customMarker = CustoMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: previewDemoData[i].img, boarderColor: UIColor.darkGray, tag: i)
            marker.iconView = customMarker
            let randInt = arc4random_uniform(4)
            if randInt == 0 {
                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long-randNum)
            } else if randInt == 1 {
                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long+randNum)
            } else if randInt == 2 {
                marker.position = CLLocationCoordinate2D(latitude: lat-randNum, longitude: long-randNum)
            } else {
                marker.position = CLLocationCoordinate2D(latitude: lat+randNum, longitude: long+randNum)
            }
            marker.map = self.myMapView
        }
    }
    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        if location != nil {
            myMapView.animate(toLocation: (location?.coordinate)!)
        }
    }
}
// MARK: CLLocation Manager Delegate
extension ViewController: CLLocationManagerDelegate{
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location: \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = location?.coordinate.latitude
        let long = location?.coordinate.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat!, longitude: long!, zoom: 17.0)
        self.myMapView.animate(to: camera)
        showPartyMarkers(lat: lat!, long: long!)
    }
 
}
//MARK: GOOGLE MAP DELEGATE
extension ViewController: GMSMapViewDelegate{
    // When marker is tapped, -> show marker Info content
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustoMarkerView else { return false }
        let img = customMarkerView.cusineImg
        let customMarker = CustoMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img!, boarderColor: .white, tag: customMarkerView.tag)
        marker.iconView = customMarker
        return false
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustoMarkerView else { return nil }
        //To determine which data to show
        let data = previewDemoData[customMarkerView.tag]
        restaurantPreview.setData(title: data.title, img: data.img)
        return restaurantPreview
    }
    //the pop out content view is tapped
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustoMarkerView else { return }
        let tag = customMarkerView.tag
        print("did Tapp Info Window")
        restaurantTapped(tag: tag)
    }
    // create the custom marker view again
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustoMarkerView else { return }
        let img = customMarkerView.cusineImg!
        customMarkerView.boarderColor = .gray
        let customMarker = CustoMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, boarderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
}
extension ViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        showPartyMarkers(lat: lat, long: long)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
        textFieldSearch.text = place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress, latitude: lat, longitude: long)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress)"
        marker.map = myMapView
        // Dismiss after place selected
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error AUTO Complete: \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    private func initGoogleMaps(){
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
}
// MARK: textfield
extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
}


