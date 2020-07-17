//
//  ViewController.swift
//  Pulley
//
//  Created by Brendan Lee on 7/6/16.
//  Copyright © 2016 52inc. All rights reserved.
//

import UIKit
import MapKit
import Pulley

class PrimaryContentViewController: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var currentRouteOverlay: MKRoute = MKRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpMapView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
           
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        let coordinateOne = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 37.2374864)!, longitude: CLLocationDegrees(exactly: -90.9092899)!)
        let coordinateTwo = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 37.2338247)!, longitude: CLLocationDegrees(exactly: -90.9917311)!)
        createRouteTo(from: coordinateOne, to: coordinateTwo)
    }
    
    func setUpMapView() {
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.delegate = self
    }
        
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        print(mapView.centerCoordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let location = locations.last! as CLLocation
        let currentLocation = location.coordinate
        
        self.currentLocation = currentLocation
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
       print(error.localizedDescription)
    }

    func createRouteTo(from: CLLocationCoordinate2D,to: CLLocationCoordinate2D) {
        
        if(CLLocationCoordinate2DIsValid(from) && CLLocationCoordinate2DIsValid(to)) {
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: from, addressDictionary: nil))
            directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: to, addressDictionary: nil))
            directionRequest.transportType = .walking
            //THIS MAKE the request for multiple routes if possible
            directionRequest.requestsAlternateRoutes = true
            
            // Calculate the direction
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate { [unowned self] (directionResponse, error) in
                guard let response = directionResponse else {
                    if let error = error {
                        print("Error: \(error)")
                        let alert = UIAlertController.init(title:"Error Creando Ruta",
                                                           message:error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction.init(title: "Aceptar", style: .destructive, handler:nil))
                        self.present(alert, animated:true , completion:nil)
                    }
                    
                    return
                }
                
                if(self.currentRouteOverlay != nil)
                {
                    self.mapView.removeOverlay(self.currentRouteOverlay.polyline)
                }

                //in response.routes you will get the routes avaiables
                for route in response.routes {
                    //Do what you need with the routes
                    print(route.polyline)
                    print(route.distance)
                    print(route.expectedTravelTime)
                    print(route.advisoryNotices)
                    print(route.steps)
                }
                
                //here I add the first to the MapView
                let route = response.routes[0]
                self.currentRouteOverlay = route
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }
        
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       let renderer = MKPolylineRenderer(overlay: overlay)
       
       renderer.strokeColor = UIColor.red;
       renderer.lineWidth = 4.0
       
       return renderer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.pulleyViewController?.displayMode = .automatic
    }

    
    @IBAction func runPrimaryContentTransitionWithoutAnimation(sender: AnyObject) {
        let primaryContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrimaryTransitionTargetViewController")

        self.pulleyViewController?.setPrimaryContentViewController(controller: primaryContent, animated: false)
    }
    
    @IBAction func runPrimaryContentTransition(sender: AnyObject) {
        let primaryContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrimaryTransitionTargetViewController")

        self.pulleyViewController?.setPrimaryContentViewController(controller: primaryContent, animated: true)
    }
}

extension PrimaryContentViewController: FriendDelegate {
    
    func makeUIAdjustmentsForFullscreen(progress: CGFloat, bottomSafeArea: CGFloat) {
        print("makeUIAdjustmentsForFullscreen")
    }
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat) {
        print("drawerChangedDistanceFromBottom")
    }
    
    func selectIndex(index: Int) {
        print("PrimaryContentViewController selectIndex", index)
        let friends = Friend().getFriends()
        let friend = friends[index]
        print("friend", friend)
        
        let coordinateOne = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 37.2374864)!, longitude: CLLocationDegrees(exactly: -90.9092899)!)
        
        let friendLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: friend.coordinate.latitude)!, longitude: CLLocationDegrees(exactly: friend.coordinate.longitude)!)
        
        createRouteTo(from: coordinateOne, to: friendLocation)
    }
}
