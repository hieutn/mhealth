//
//  AppDelegate+Notification.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/18/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import Foundation
import MapKit
import TSMessages

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleRegionEvent(region)
        }
    }
    
    private func handleRegionEvent(region: CLRegion) {
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