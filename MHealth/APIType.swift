//
//  APIType.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import Alamofire

protocol APIType: URLRequestConvertible {
    
    ///
    var baseURL: NSURL { get }
    var path: String { get }
    var method: Alamofire.Method { get }
    var parameters: [String: AnyObject]? { get }
    
}

extension APIType {
    
    var baseURL: NSURL {
        return NSURL(string: "https://mhealth-leanh215.c9users.io/")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Alamofire.Method {
        return .POST
    }
    
    var parameters: [String: AnyObject]? {
        return nil
    }
    
    var URLRequest: NSMutableURLRequest {
        let url = NSURL(string: path, relativeToURL: baseURL)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        
        return ParameterEncoding.JSON.encode(request, parameters: parameters).0
    }
    
}


enum MHealthAPI {
    
    case Location
    case Doctors
    
}


extension MHealthAPI: APIType {
    
    var path: String {
        switch self {
        case .Location: return "api1.php"
        case .Doctors: return "api2.php"
        }
    }
    
}
