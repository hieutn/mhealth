//
//  LocationViewModel.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift

final class LocationViewModel: NSObject {
    
    dynamic private(set) var isLoading: Bool = false
    dynamic private(set) var error: String?
    
    var location: Location?
    
    private lazy var reachability = try! Reachability.reachabilityForInternetConnection()
    
    func getLocation() {
        if reachability.isReachableViaWiFi() {
            isLoading = true
            
            APIProvider.shareProvider
                .request(MHealthAPI.Location).responseObject(keyPath: "data") { (response: Response<Location, NSError>) in
                    self.location = response.result.value
                    self.error = response.result.error?.localizedDescription
                    self.isLoading = false
            }
        } else {
            error = "Enable Wifi to get Location"
        }
    }
    
}