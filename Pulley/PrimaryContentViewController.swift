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
    public var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var destinationLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
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
        
        self.currentLocation = coordinateOne
        let coordinateTwo = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: 37.2338247)!, longitude: CLLocationDegrees(exactly: -90.9917311)!)
        
        createRouteTo(from: coordinateOne, to: coordinateTwo, transportType:.automobile)
        createRouteTo(from: coordinateOne, to: coordinateTwo, transportType:.walking)
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
        
//        self.currentLocation = currentLocation
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
        locationManager.stopUpdatingLocation()
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
       print(error.localizedDescription)
    }

    func createRouteTo(from: CLLocationCoordinate2D,to: CLLocationCoordinate2D, transportType: MKDirectionsTransportType) {
        
        if(CLLocationCoordinate2DIsValid(from) && CLLocationCoordinate2DIsValid(to)) {
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: from, addressDictionary: nil))
            directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: to, addressDictionary: nil))
            directionRequest.transportType = transportType
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
                self.pulleyViewController?.routeCalced(route: route)
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
        self.destinationLocation = friendLocation
        createRouteTo(from: coordinateOne, to: friendLocation, transportType:.walking)
    }
    
    func calculateRoute(transportType: MKDirectionsTransportType){
        createRouteTo(from: self.currentLocation, to: self.destinationLocation, transportType:transportType)
    }
    
    func openDirectionsApp() {
        print("openDirectionsApp")
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
           
        // 2
        let appleMapAction = UIAlertAction(title: "Open in Apple Map", style: .default,  handler: {
            (alert: UIAlertAction!) -> Void in
            print("Deleted")
            self.appleMapClicked()
        })
        let googleMapAction = UIAlertAction(title: "Open in Google Map", style: .default,  handler: {
            (alert: UIAlertAction!) -> Void in
            print("Deleted")
            self.googleMapClicked()
       })
        
        let uberAction = UIAlertAction(title: "Open in Uber", style: .default,  handler: {
            (alert: UIAlertAction!) -> Void in
            print("Uber")
            self.uberClicked()
        })
        
        let lyftMapAction = UIAlertAction(title: "Open in Lyft", style: .default,  handler: {
            (alert: UIAlertAction!) -> Void in
            print("Lyft")
            self.lyftClicked()
        })
        
        let wazeAction = UIAlertAction(title: "Open in Waze", style: .default,  handler: {
            (alert: UIAlertAction!) -> Void in
            print("Waze")
            self.wazeClicked()
        })
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
           
       // 4
        optionMenu.addAction(appleMapAction)
        optionMenu.addAction(googleMapAction)
        optionMenu.addAction(uberAction)
        optionMenu.addAction(lyftMapAction)
        optionMenu.addAction(wazeAction)
        optionMenu.addAction(cancelAction)

       // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func uberClicked() {
        if isInstalledOf(app: "uber") {
            open(scheme: "uber://?action=setPickup&client_id=7r6zjXf5e1p4nqYkX17d9R44estKs-na&product_id=a12ab23b-66f0-4028-9bb9-856dbcfdbbc7&pickup[formatted_address]=5874%20Newberry%20Street%2C%20Romulus%2C%20MI%2C%20USA&pickup[latitude]=42.265570&pickup[longitude]=-83.387391&dropoff[formatted_address]=15609%20Regina%20Avenue%2C%20Allen%20Park%2C%20MI%2C%20USA&dropoff[latitude]=42.253737&dropoff[longitude]=-83.211945")
        } else {
            open(scheme: "https://m.uber.com/ul/")
        }
    }

    func lyftClicked() {
        if isInstalledOf(app: "lyft") {
            open(scheme: String(format: "lyft://ridetype?id=lyft&pickup[latitude]=%f&pickup[longitude]=%f&destination[latitude]=%f&destination[longitude]=%f",
            self.currentLocation.latitude, self.currentLocation.longitude, self.destinationLocation.latitude, self.destinationLocation.longitude))
        } else {
            open(scheme: "https://www.lyft.com/signup/SDKSIGNUP?clientId=IcEuyAmFO7Gp&sdkName=iOS_direct")
        }
    }

    // check if the app is installed
    func isInstalledOf(app: String) -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "\(app)://")!)
    }

    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func wazeClicked() {
           if isInstalledOf(app: "waze") {
           } else {
               open(scheme: "http://itunes.apple.com/us/app/id323229106")
           }
       }

    
    func openWaze(location : CLLocationCoordinate2D) {
        if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
            // Waze is installed. Launch Waze and start navigation
            let urlStr: String = "waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes"
            UIApplication.shared.openURL(URL(string: urlStr)!)
        }
        else {
            // Waze is not installed. Launch AppStore to install Waze app
            UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/us/app/id323229106")!)
        }
    }
    
    func googleMapClicked() {
        let url:URL! = self.prepareURIFor( latitude: self.destinationLocation.latitude, longitude:self.destinationLocation.longitude,fromLatitude: self.currentLocation.latitude,
                                      fromLongitude:self.currentLocation.longitude,
                                      navigation: PrimaryContentViewController.NavigationType.walking)
        if isInstalledOf(app: "comgooglemaps") {
             UIApplication.shared.openURL(url)
        } else {
              NSLog("Can't use Google Maps");
        }
    }
    
    func appleMapClicked() {
        if isInstalledOf(app: "http://maps.apple.com") {
            open(scheme:  "http://maps.apple.com/?daddr=San+Francisco,+CA&saddr=cupertino");
        } else {
              NSLog("Can't use Apple Maps");
        }
    }
    
    public enum NavigationType: String {
      case driving
      case transit
      case walking
    }
    
    func prepareURIFor(latitude lat: Double,
                                    longitude long: Double,
                                    fromLatitude fromLat: Double? = nil,
                                    fromLongitude fromLong: Double? = nil,
                                    navigation navigateBy: NavigationType) -> URL? {
      if let googleMapsRedirect = URL(string: "comgooglemaps://"),
        UIApplication.shared.canOpenURL(googleMapsRedirect) {

        if let fromLat = fromLat,
          let fromLong = fromLong {

          let urlDestination = URL(string: "comgooglemaps-x-callback://?saddr=\(fromLat),\(fromLong)?saddr=&daddr=\(lat),\(long)&directionsmode=\(navigateBy.rawValue)")
          return urlDestination

        } else {

          let urlDestination = URL(string: "comgooglemaps-x-callback://?daddr=\(lat),\(long)&directionsmode=\(navigateBy.rawValue)")
          return urlDestination
        }
      } else {
        if let fromLat = fromLat,
          let fromLong = fromLong {

          let urlDestination = URL(string: "https://www.google.com/maps/dir/?saddr=\(fromLat),\(fromLong)&daddr=\(lat),\(long)&directionsmode=\(navigateBy.rawValue)")
          return urlDestination

        } else {

          let urlDestination = URL(string: "https://www.google.com/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=\(navigateBy.rawValue)")
          return urlDestination
        }
      }
    }
}
