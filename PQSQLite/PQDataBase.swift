//
//  DataBase.swift
//  HappyFamily
//
//  Created by pgq on 2018/4/8.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import SQLite


open class PQDataBase: NSObject {

    /// 数据库对象
    public static var db: Connection = try! Connection(.temporary, readonly: false)
    /// 缓存数据对象
    public static var cache = PQCache()
    
    
    /// 打开数据库
    ///
    /// - Parameter fileName: 数据库地址
    /// - Parameter closure: 用来创建表
    /// - Throws: 用来抛出异常
    public class func open(fileName: String, closure:@escaping () -> ()) throws {
        
        try db = Connection(fileName)
        closure()
        
        
        // 超时时间
        db.busyTimeout = 5
        // 最多处理次数
        db.busyHandler {
            if $0 >= 5 {
                return false
            }
            return true
        }
        
        // MARK: - cache
        cache.countLimit = 30
        cache.willClear { (string) in
            do {
                try db.transaction {
                    string.forEach {
                     PQDataBase.run($0)
                    }
                }
            } catch {
                print("open transaction failed", error)
            }
        }
    }
    
    public class func close() {
        db = try! Connection(.temporary, readonly: false)
    }
    
    @discardableResult
    public class func run(_ insert: Insert) -> Bool {
        do{
            try db.run(insert)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    @discardableResult
    public class func run(_ update: Update) -> Bool {
        do{
            try db.run(update)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    @discardableResult
    public class func run(_ delete: Delete) -> Bool {
        do{
            try db.run(delete)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    @discardableResult
    public class func run(_ statement: String, _ bindings: Binding?...) -> Bool {
        do{
            try db.run(statement,bindings)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    @discardableResult
    public class func run(_ statement: String, _ bindings: [Binding?]) -> Bool {
        do{
            try db.run(statement,bindings)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    @discardableResult
    public class func run(_ statement: String, _ bindings: [String : Binding?]) -> Bool {
        do{
            try db.run(statement,bindings)
            return true
        }catch{
            print(error)
            return false
        }
    }
    
    // MARK: - auto
    public class func synchronize() {
        cache.synchronize()
    }
    public class func autoRun(_ insert: Insert) {
        cache.add(value: insert.asSQL())
    }
    
    public class func autoRun(_ update: Update) {
        cache.add(value: update.asSQL())
    }
    
    public class func autoRun(_ delete: Delete) {
        cache.add(value: delete.asSQL())
    }
    
    /*
    class func autoRun(_ statement: String, _ bindings: Binding?...) {
        do{
            try db.run(statement,bindings)
        }catch{
            print(error)
        }
    }
    
    class func autoRun(_ statement: String, _ bindings: [Binding?]) {
        do{
            try db.run(statement,bindings)
        }catch{
            print(error)
        }
    }
    
    class func autoRun(_ statement: String, _ bindings: [String : Binding?]) {
        do{
            try db.run(statement,bindings)
        }catch{
            print(error)
        }
    }
 */
}
