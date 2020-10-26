//
//  Database.swift
//  RestServer
//
//  Created by ITLoaner on 9/24/20.
//  Modified by Thomas Clark on 10/25

import SQLite3
import Foundation

class Database {
    static var dbObj : Database!
    let dbname = "/Users/dg/Documents/PesonDb.sqlite"
    var conn : OpaquePointer!

    init() {
        // 1. create database
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            // create tables
            initializeDB()
            sqlite3_close(conn)
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Open database failed due to error \(errcode)")
        }
    }

    private func initializeDB() {
        var sqlStmt = "create table if not exists person (first_name text, last_name text, ssn text)"
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Create table failed due to error \(errcode)")
        }
        sqlStmt = "create table if not exists Claim (id text, title text, date text, isSolved boolean)"
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Create table failed due to error \(errcode)")
        }
    }

    func getDbConnection() -> OpaquePointer? {
        var conn : OpaquePointer?
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            return conn
        } else {
            let errcode = sqlite3_errcode(conn)
            let errmsg = sqlite3_errmsg(conn)
            print("Open database failed due to error \(errcode)")
            print("Open database failed due to error \(errmsg!)")
            let _ = String(format:"%@", errmsg!)
            //let len = strlen(errmsg)
            //let data = Data(bytes: errmsg!, count: len)
        }
        return conn
    }
    
    static func getInstance() -> Database {
        if dbObj == nil {
            dbObj = Database()
        }
        return dbObj
    }
}
