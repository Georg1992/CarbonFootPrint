//
//  MapViewController.swift
//  CarbonFootprintTracking
//
//  Created by Patrik on 20.4.2021.
//

import UIKit
import MOPRIMTmdSdk
import MapKit
import CoreLocation
import FloatingPanel

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, FloatingPanelControllerDelegate {
    
    @IBOutlet weak var textFieldForStart: UITextField!
    @IBOutlet weak var textFieldForAddress: UITextField!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // declearing floatingPanel
        let panel = FloatingPanelController()
        panel.delegate = self
        
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "fpc_vehicle") as? VehicleViewController
        else {
            return
        }
        
        panel.set(contentViewController: contentVC)
        panel.addPanel(toParent: self)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.delegate = self
        
        textFieldForStart.placeholder = "Own Location"
        textFieldForAddress.placeholder = "Destination Location"
    }
    
    // fetches user location via reverseGeocodeLocation
    @IBAction func useYourLocation(_ sender: UIButton) {
        
        guard let sourceCoordinate = locationManager.location?.coordinate else {
            print("No Location")
            return
        }
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location)
        {placemarks, error in
            if(error != nil) {
                print("reverse geocoding fail")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                
                if pm.locality != nil {
                    self.textFieldForStart.text = pm.locality
                } else {
                    self.textFieldForStart.text = "No Location Found"
                }
            }
        }
    }
    
    @IBAction func getDirectionTapped(_ sender: UIButton) {
        getAddress()
    }
    // fetches locations for start point and end point
    func getAddress() {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(textFieldForAddress.text ?? "nottingham") { (placemarks, error)
            in
            guard let placemarks = placemarks, let destinationLocation = placemarks.first?.location
            else {
                print("No Location Found")
                return
            }
            
            geoCoder.geocodeAddressString(self.textFieldForStart.text ?? "liverpool") { (placemarks, error)
                in
                guard let placemarks = placemarks, let startLocation = placemarks.first?.location
                else {
                    print("no location found")
                    return
                }
                // calls mapthis function with start and destination coordinates as parameter
                self.mapThis(destinationCord: destinationLocation.coordinate, startCord: startLocation.coordinate)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations \(locations)")
    }
    
    // fetches route by using start and destination coordinates
    func mapThis(destinationCord : CLLocationCoordinate2D, startCord : CLLocationCoordinate2D) {
        
        // let sourceCoordinate = (locationManager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: startCord)
        let destPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { [self] (response, error) in
            guard let response = response else {
                if error != nil {
                    print("Something is wrong")
                }
                return
            }
            
            let route = response.routes[0]
            print("this many kilometers \(route.distance / 1000)km")
            self.map.removeOverlays(self.map.overlays)
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            // change distance variable in vehicleViewController which should trigger tableView.reloadData() (not working)
            let distance = (route.distance/1000)
            let vehicleViewController = VehicleViewController()
            vehicleViewController.distance = distance
            
        }
        
        
    }
    
    //render line from route
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
