//
//  Location.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class Location: Object {
    
    dynamic var lattitude: Double = 0.0
    dynamic var longtitude: Double = 0.0
    dynamic var radius: Double = 0.0
    
}


extension Location: Mappable {
    
    convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        lattitude <- map["lattitude"]
        longtitude <- map["longitude"]
        radius <- map["radius"]
    }
    
}
