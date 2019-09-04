//
//  PQCache.swift
//  Lumary
//
//  Created by 盘国权 on 2018/12/27.
//  Copyright © 2018 pgq. All rights reserved.
//

import Foundation


open class PQCache: NSObject {
    public typealias PQCacheValues = ([String]) -> Void
    /// default 30
    public var countLimit: Int = 30
    /// default 30s
    public var syncTimeInterval = 30
    
    
    private var values: [String] = []
    private var valuesClosure: PQCacheValues?
}

public extension PQCache {
    func add(value: String) {
        objc_sync_enter(self)
        values.append(value)
        if values.count == countLimit {
            valuesClosure?(values)
            removeAll()
        }
        objc_sync_exit(self)
    }
    
    func remove(at index: Int) {
        objc_sync_enter(self)
        values.remove(at: index)
        objc_sync_exit(self)
    }
    
    func removeAll() {
        objc_sync_enter(self)
        values.removeAll()
        objc_sync_exit(self)
    }
    
    func willClear(_ closure: PQCacheValues?){
        valuesClosure = closure
    }
    
    func synchronize() {
        valuesClosure?(values)
        removeAll()
    }
}
