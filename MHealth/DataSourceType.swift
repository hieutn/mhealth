//
//  DataSourceType.swift
//  MHealth
//
//  Created by Tran Ngoc Hieu on 6/18/16.
//  Copyright © 2016 MHealth. All rights reserved.
//

import Foundation

protocol DataSourceType {
    
    associatedtype ModelType
    
    var datasource: [ModelType] { get }
    
    func numberOfSection() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    
    subscript(index: NSIndexPath) -> ModelType { get }
    
}

extension DataSourceType {
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return datasource.count
    }
    
    subscript(index: NSIndexPath) -> ModelType {
        get {
            return datasource[index.row]
        }
    }
    
}