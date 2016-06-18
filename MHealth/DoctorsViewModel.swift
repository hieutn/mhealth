//
//  DoctorsViewModel.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ReachabilitySwift


final class DoctorsViewModel: NSObject, DataSourceType {
    
    /// Outputs
    dynamic private(set) var isLoading: Bool = false
    dynamic private(set) var error: String?
    dynamic private(set) var isSavingData: Bool = false
    dynamic private(set) var saveError: String?
    
    var datasource: [Doctor] = []
    var dataManager: DataManagerType!
    
    private lazy var reachability = try! Reachability.reachabilityForInternetConnection()
    
    func getDoctors() {
        if reachability.isReachableViaWWAN() {
            isLoading = true
            
            APIProvider.shareProvider
                .request(MHealthAPI.Doctors)
                .responseArray(keyPath: "data") { (response: Response<[Doctor], NSError>) in
                    self.datasource = response.result.isFailure ? [] : response.result.value!
                    self.error = response.result.error?.localizedDescription
                    self.isLoading = false
            }
        } else {
            error = "Enable Cellular to get Doctors"
        }
    }
    
    func saveDoctors() {
        isSavingData = true
        
        dataManager.saveDoctors(datasource) { [weak self] (success, error) in
            self?.saveError = success ? nil : error!.localizedDescription
            self?.isSavingData = false
        }
    }
    
}