//
//  DataManager.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/17/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import RealmSwift

typealias SaveCompletionHandler = (success: Bool, error: NSError?) -> Void


protocol DataManagerType {
    
    func saveDoctors(doctors: [Doctor], completionHandler: SaveCompletionHandler)
    
}

class RealmDataManager: DataManagerType {
    
    func saveDoctors(doctors: [Doctor], completionHandler: SaveCompletionHandler) {
        autoreleasepool {
            do {
                let realm = try Realm()
                
                try realm.write {
                    realm.add(doctors)
                }
                
                completionHandler(success: true, error: nil)
            } catch {
                completionHandler(success: false, error: error as NSError)
            }
        }
    }
    
}
