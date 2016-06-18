//
//  LocationViewController.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import UIKit
import MapKit
import KVOController
import SVProgressHUD
import TSMessages


final class LocationViewController: UIViewController {
    
    var viewModel = LocationViewModel()
    
    private let locationManager = CLLocationManager()
    private var kvoController: FBKVOController!
    private var region: CLCircularRegion?
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingModel()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getLocation()
    }
    
    deinit {
        stopTracking()
    }
    
    private func bindingModel() {
        kvoController = FBKVOController(observer: self)
        
        kvoController.observe(viewModel, keyPath: "isLoading", options: .New) { (observer, object, change) in
            if let isLoading = change[NSKeyValueChangeNewKey] as? Bool where isLoading {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
        
        kvoController.observe(viewModel, keyPath: "error", options: .New) { (observer, object, change) in
            if let error = change[NSKeyValueChangeNewKey] as? String {
                TSMessage.showNotificationInViewController(self, title: "", subtitle: error, type: .Error)
            } else {
                self.trackingUserLocation()
                self.trackRegion(withLocation: self.viewModel.location!)
            }
        }
    }
    
}

/// Tracking user location and region
extension LocationViewController {
    
    private func trackingUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func trackRegion(withLocation location: Location) {
        guard CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) else {
            TSMessage.showNotificationWithTitle("Circular region is not supported on this device!", type: .Warning)
            return
        }
        
        setMapRegion(location)
        
        addOverlayRegion(location)
        
        let center = CLLocationCoordinate2D(latitude: location.lattitude, longitude: location.longtitude)
        region = CLCircularRegion(center: center, radius: location.radius, identifier: "HealthRegion")
        if let region = self.region {
            region.notifyOnEntry = true
            region.notifyOnExit = false
            locationManager.startMonitoringForRegion(region)
        }
    }
    
    private func setMapRegion(location: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: location.lattitude, longitude: location.longtitude)
        
        var trackRegion = MKCoordinateRegionMakeWithDistance(coordinate, 2500, 2500)
        trackRegion = mapView.regionThatFits(trackRegion)
        mapView.setRegion(trackRegion, animated: true)
    }
    
    private func addOverlayRegion(location: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: location.lattitude, longitude: location.longtitude)
        
        let circleOverlay = MKCircle(centerCoordinate: coordinate, radius: location.radius)
        circleOverlay.title = "Tracked Region"
        mapView.addOverlay(circleOverlay)
    }
    
    private func stopTracking() {
        locationManager.stopUpdatingLocation()
        if let region = self.region {
            locationManager.stopMonitoringForRegion(region)
        }
    }
    
}


extension LocationViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied {
            TSMessage.showNotificationWithTitle("Please grant location service permission to monitoring user location and region.", type: .Warning)
        } else {
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            if UIApplication.sharedApplication().applicationState == .Active {
                TSMessage.showNotificationWithTitle("Entered", type: .Message)
            } else {
                let notification = UILocalNotification()
                notification.alertBody = "Entered"
                notification.soundName = "Default";
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("Start monitoring region \(region.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print(error)
    }
    
}

extension LocationViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.cyanColor().colorWithAlphaComponent(0.2)
        renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
        renderer.lineWidth = 2.0
        return renderer
    }
    
}
