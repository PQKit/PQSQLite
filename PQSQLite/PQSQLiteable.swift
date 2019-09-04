//
//  SqliteProtocol.swift
//  Light
//
//  Created by 盘国权 on 2018/10/18.
//  Copyright © 2018年 pgq. All rights reserved.
//

import Foundation
import SQLite


public protocol PQSQLiteable: Codable {
    /// 表对象
    static var table: Table { get }
    /// 创建表
    static func createTable()
    /// 谓词
    var predicate: Expression<Bool> { get }
    
    /// insert to sqlite, use `predicate`
    ///
    /// - Returns: is inserted
    @discardableResult
    func insert() -> Bool
    
    /// insert to sqlite when predicate is true
    ///
    /// - Parameter predicate: predicate
    /// - Returns: is inserted
    @discardableResult
    func insert(predicate: Expression<Bool>) -> Bool
    
    /// auto insert, May not execute immediately
    ///
    /// - Returns: nothing
    func autoInsert()
    
    /// auto insert, May not execute immediately
    ///
    /// - Returns: nothing
    func autoInsert(predicate: Expression<Bool>)
    
    /// delete this data, use `predicate`
    ///
    /// - Returns: is deleted
    @discardableResult
    func delete() -> Bool
    
    /// delete this data when predicate is true
    ///
    /// - Parameter predicate: predicate
    /// - Returns:  is deleted
    @discardableResult
    func delete(predicate: Expression<Bool>) -> Bool
    
    /// auto delete, May not execute immediately
    ///
    /// - Returns: nothing
    func autoDelete()
    
    /// auto delete, May not execute immediately
    ///
    /// - Returns: nothing
    func autoDelete(predicate: Expression<Bool>)
    
    /// update this data, use `predicate`
    ///
    /// - Returns:  is updated
    @discardableResult
    func update() -> Bool
    
    /// update this data when predicate is true
    ///
    /// - Parameter predicate: predicate
    /// - Returns: is updated
    @discardableResult
    func update(predicate: Expression<Bool>) -> Bool
    
    /// auto update, May not execute immediately
    ///
    /// - Returns: nothing
    func autoUpdate()
    
    /// auto update, May not execute immediately
    ///
    /// - Returns: nothing
    func autoUpdate(predicate: Expression<Bool>)
    
    /// query data, use `predicate`
    ///
    /// - Returns: [Self]
    func query() -> [Self]
    
    /// query data when predicate is true
    ///
    /// - Parameter predicate: predicate
    /// - Returns: [Self]
    func query(predicate: Expression<Bool>) -> [Self]
    
    /// query data when predicate is true
    ///
    /// - Parameter predicate: predicate
    /// - Returns: [Self]
    static func query(predicate: Expression<Bool>) -> [Self]
    
    /// query all data
    ///
    /// - Returns: [Self]
    static func queryAll() -> [Self]
}

public extension PQSQLiteable {
   // MARK: - insert
    @discardableResult
    func insert() -> Bool {
        return insert(predicate: predicate)
    }
    
    @discardableResult
    func insert(predicate: Expression<Bool>) -> Bool {
        if !query(predicate: predicate).isEmpty {
            return update(predicate: predicate)
        }
        
        do {
            let insertSql = try Self.table.insert(self)
            return PQDataBase.run(insertSql)
        } catch {
            print("insert 解析失败", error)
            return false
        }
    }
    
    func autoInsert() {
        autoInsert(predicate: predicate)
    }
    
    func autoInsert(predicate: Expression<Bool>) {
        if !query(predicate: predicate).isEmpty {
            update(predicate: predicate)
        }
        
        do {
            let insertSql = try Self.table.insert(self)
            PQDataBase.autoRun(insertSql)
        } catch {
            print(#function, "insert 解析失败", error)
        }
    } 
    
    // MARK: - delete
    @discardableResult
    func delete() -> Bool {
        return delete(predicate: predicate)
    }
    
    @discardableResult
    func delete(predicate: Expression<Bool>) -> Bool {
        let filterTable = Self.table.filter(predicate)
        return PQDataBase.run(filterTable.delete())
    }
    
    func autoDelete() {
        autoDelete(predicate: predicate)
    }
    
    func autoDelete(predicate: Expression<Bool>) {
        let filterTable = Self.table.filter(predicate)
        PQDataBase.autoRun(filterTable.delete())
    }
    
    // MARK: - update
    @discardableResult
    func update() -> Bool {
        return update(predicate: predicate)
    }
    
    @discardableResult
    func update(predicate: Expression<Bool>) -> Bool {
        let filterTable = Self.table.filter(predicate)
        do {
            let updateSql = try filterTable.update(self)
            return PQDataBase.run(updateSql)
        } catch {
            print("update 转换sql语句错误",error)
            return false
        }
    }
    
    func autoUpdate() {
        autoUpdate(predicate: predicate)
    }
    
    func autoUpdate(predicate: Expression<Bool>) {
        let filterTable = Self.table.filter(predicate)
        do {
            let updateSql = try filterTable.update(self)
            PQDataBase.autoRun(updateSql)
        } catch {
            print("update 转换sql语句错误",error)
        }
    }

    // MARK: - query
    func query() -> [Self] {
        return query(predicate: predicate)
    }
    
    func query(predicate: Expression<Bool>) -> [Self] {
        return Self.query(predicate: predicate)
    }
    
    static func query(predicate: Expression<Bool>)  -> [Self] {
        let filterTable = table.filter(predicate)
        return queryTable(filterTable)
    }
    
    static func queryAll() -> [Self] {
        return queryTable(table)
    }
    
    static private func queryTable(_ table: Table) -> [Self] {
        do {
            return try PQDataBase.db
                .prepare(table)
                .map { (row) -> Self in
                    return try row.decode()
            }
        } catch {
            print("query 转换sql语句错误",error)
            return []
        }
    }
}


