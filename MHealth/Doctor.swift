//
//  Doctor.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import RealmSwift
import ObjectMapper

final class Doctor: Object {
    
    dynamic var doctorId: Int = 0
    dynamic var name: String = ""
    dynamic var type: String = ""
    dynamic var available: Bool = false
    dynamic var url: String?
    
}


extension Doctor: Mappable {
    
    convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        doctorId <- map["id"]
        name <- map["doctor_name"]
        type <- map["doctor_type"]
        available <- map["doctor_available"]
        url <- map["avatar_url"]
    }
    
}

extension String {
    
    /// Replace white space character by percent
    var URLEscapedString: String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
    }
    
}