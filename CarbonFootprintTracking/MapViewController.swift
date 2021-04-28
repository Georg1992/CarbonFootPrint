//
//  MapViewController.swift
//  CarbonFootprintTracking
//
//  Created by iosdev on 20.4.2021.
//

import UIKit
import MOPRIMTmdSdk
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var textFieldForStart: UITextField!
    @IBOutlet weak var textFieldForAddress: UITextField!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.delegate = self
        }
    
    @IBAction func getDirectionTapped(_ sender: UIButton) {
        getAddress()
    }
    
    func getAddress() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(textFieldForAddress.text ?? "Helsinki") { (placemarks, error)
            in
            guard let placemarks = placemarks, let location = placemarks.first?.location
            else {
                print("No Location Found")
                return
            }
            print(location)
            self.mapThis(destinationCord: location.coordinate)
        }
    }
    
    func getStart() {
        print("this is \(textFieldForStart.text)")
        let geoCoder = CLGeocoder()
        var coordinates : CLLocationCoordinate2D?
        geoCoder.geocodeAddressString(textFieldForStart.text ?? "Helsinki") { (placemarks, error)
            in
            guard let placemarks = placemarks, let location = placemarks.first?.location
            else {
                print("No Location Found")
                return
            }
            print("this is location\(location)")
            coordinates = location.coordinate
        }
        print("this is \(coordinates?.latitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations \(locations)")
    }
    
    func mapThis(destinationCord : CLLocationCoordinate2D) {
        
        let sourceCoordinate = (locationManager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Something is wrong")
                }
                return
            }
            
            let route = response.routes[0]
            print("this many kilometers \(route.distance / 1000)km")
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
        }
        
        
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
