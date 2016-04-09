import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var searchUser: Bool = false
    var location: CLLocation?
    var poi: [MKAnnotation]!
    var currentAnnotation: MKAnnotation?
    var currentIndex = 0
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView;
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        NSLayoutConstraint.activateConstraints([topConstraint, leadingConstraint, trailingConstraint])
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        let currentLocationButton = UIButton(type: .System)
        currentLocationButton.setTitle("Find me", forState: .Normal)
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.addSubview(currentLocationButton)
        
        let buttonBottomConstraint = currentLocationButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        let buttonLeadingConstraint = currentLocationButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activateConstraints([buttonBottomConstraint, buttonLeadingConstraint])
        
        currentLocationButton.addTarget(self, action: "findMe:", forControlEvents: .TouchUpInside)
        
        let poiButton = UIButton(type: .System)
        poiButton.setTitle("POI", forState: .Normal)
        poiButton.translatesAutoresizingMaskIntoConstraints = false
        
        let poiButtonBottomConstraint = poiButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor)
        let poiButtonTrailingConstraint = poiButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor, constant: 10)
        
        mapView.addSubview(poiButton)
        
        NSLayoutConstraint.activateConstraints([poiButtonBottomConstraint, poiButtonTrailingConstraint])
        
        poiButton.addTarget(self, action: "togglePoi:", forControlEvents: .TouchUpInside)
        
        
    }
    override func viewDidLoad() {
        print("Loading map view controller.")
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let home = MKPointAnnotation()
        home.coordinate = CLLocationCoordinate2D(latitude: 36.0444580, longitude: -86.6279120)
        home.title = "Home"
        
        let birthPlace = MKPointAnnotation()
        birthPlace.coordinate = CLLocationCoordinate2D(latitude: 42.2586340, longitude: -87.8406250)
        birthPlace.title = "Birthplace"
        
        let disney = MKPointAnnotation()
        disney.coordinate = CLLocationCoordinate2D(latitude: 28.3978940, longitude: -81.5708260)
        disney.title = "DISNEY WORLD!"
        
        poi = [home, birthPlace, disney]
    }
    
    func mapTypeChanged(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }
    
    func findMe(button: UIButton) {
        searchUser = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            if(searchUser) {
                let region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapView.setRegion(region, animated: true)
                locationManager.stopUpdatingLocation()
                searchUser = false
            }
            self.location = currentLocation
        }
        manager.stopUpdatingLocation()
    }
    
    func togglePoi(sender: UIButton) {
        let toggledLocation = poi[currentIndex]
        if let previous = currentAnnotation {
            mapView.removeAnnotation(previous)
        }
        mapView.addAnnotation(toggledLocation)
        currentAnnotation = toggledLocation
        currentIndex++
        if(currentIndex >= poi.count) {
            currentIndex = 0
        }
    }
    
}