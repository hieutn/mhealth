//
//  MainTabBarController.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/18/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import UIKit
import ReachabilitySwift
import TSMessages

class MainTabBarController: UITabBarController {

    lazy var reachability = try! Reachability.reachabilityForInternetConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeNetwork()
    }
    
    private func observeNetwork() {
        reachability.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    TSMessage.showNotificationWithTitle("Reachable via WiFi", subtitle: "", type: .Message)
                } else {
                    TSMessage.showNotificationWithTitle("Reachable via Cellular", subtitle: "", type: .Message)
                }
            }
        }
        
        reachability.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                TSMessage.showNotificationWithTitle("No Network connection", subtitle: "", type: TSMessageNotificationType.Message)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
}
