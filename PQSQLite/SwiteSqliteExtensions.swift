//
//  SwiteSqliteExtensions.swift
//  BaseAPP
//
//  Created by pgq on 2017/12/16.
//  Copyright © 2017年 pgq. All rights reserved.
//

import UIKit
import SQLite

public extension String {
    func expressionString() -> Expression<String> {
        return Expression<String>(self)
    }
    
    func expressionOptionalString() -> Expression<String?> {
        return Expression<String?>(self)
    }
    
    func expressionInt() -> Expression<Int> {
        return Expression<Int>(self)
    }
    
    func expressionOptionalInt() -> Expression<Int?> {
        return Expression<Int?>(self)
    }
    
    func expressionDouble() -> Expression<Double> {
        return Expression<Double>(self)
    }
    func expressionOptionalDouble() -> Expression<Double?> {
        return Expression<Double?>(self)
    }
    
    func expressionData() -> Expression<Data> {
        return Expression<Data>(self)
    }
    
    func expressionOptionalData() -> Expression<Data?> {
        return Expression<Data?>(self)
    }
    
    func expressionDate() -> Expression<Date> {
        return Expression<Date>(self)
    }
    
    func expressionOptionalDate() -> Expression<Date?> {
        return Expression<Date?>(self)
    }
    
    func expressionBlob() -> Expression<Blob> {
         return Expression<Blob>(self)
    }
    
    func expressionBool() -> Expression<Bool> {
        return Expression<Bool>(self)
    }

}

