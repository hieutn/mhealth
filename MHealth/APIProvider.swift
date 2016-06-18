//
//  APIProvider.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import Alamofire
import AlamofireNetworkActivityIndicator

struct APIProvider {
    
    static let shareProvider: Manager = {
        let configuration: NSURLSessionConfiguration = {
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            config.URLCache = nil
            config.timeoutIntervalForRequest = 300
            config.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
            
            return config
        }()
        
        NetworkActivityIndicatorManager.sharedManager.isEnabled = true
        return Manager(configuration: configuration)
    }()
    
}
