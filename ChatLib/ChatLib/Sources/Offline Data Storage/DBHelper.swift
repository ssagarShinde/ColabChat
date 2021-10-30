//
//  DBHelper.swift
//  ChatLib
//
//  Created by Sagar on 14/10/21.
//

import UIKit
import SQLite3

internal class DBHelper {
    init() {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        
        let createTableString = "CREATE TABLE IF NOT EXISTS person(assignedToAgent, assignedToTeam,caseSource, createdDate, emailCC, fullName, lastIxnBy,lastIxnDate,primaryEmail,  primaryPhone, requestedBy, requestorRemark, status, subject, uCreatedDate, uLastIxnDate TEXT, caseid TEXT PRIMARY KEY);"
        
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("History table created.")
            } else {
                print("History table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(assignedToAgent: String, assignedToTeam: String, caseSource: String, createdDate: String, emailCC: String, fullName: String, lastIxnBy: String, lastIxnDate: String, primaryEmail: String, primaryPhone: String, requestedBy: String, requestorRemark: String, status: String, subject: String, uCreatedDate: String, uLastIxnDate: String, caseid: String) {
        
        let history = read()
        for idx in history {
            if ((idx.caseid ?? "") == caseid) {
                return
            }
        }
        let insertStatementString = "INSERT INTO person (assignedToAgent, assignedToTeam,caseSource, createdDate, emailCC, fullName, lastIxnBy,lastIxnDate,primaryEmail,  primaryPhone, requestedBy, requestorRemark, status, subject, uCreatedDate, uLastIxnDate, caseid) VALUES (?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?);"
        
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (assignedToAgent as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 2, (assignedToTeam as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 3, (caseSource as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 4, (createdDate as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 5, (emailCC as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 6, (fullName as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 7, (lastIxnBy as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 8, (lastIxnDate as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 9, (primaryEmail as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 10, (primaryPhone as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 11, (requestedBy as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 12, (requestorRemark as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 13, (status as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 14, (subject as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 15, (uCreatedDate as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 16, (uLastIxnDate as NSString).utf8String, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatement, 17, (caseid as NSString).utf8String, -1, SQLITE_TRANSIENT)
            
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print(insertStatement.debugDescription)
               // print("Could not insert row.")
            }
        } else {
           // print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [History] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [History] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let assignedToAgent = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let assignedToTeam = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let caseSource = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let createdDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let emailCC = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let fullName = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let lastIxnBy = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let lastIxnDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let primaryEmail = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let primaryPhone = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                let requestedBy = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                let requestorRemark = String(describing: String(cString: sqlite3_column_text(queryStatement, 11)))
                let status = String(describing: String(cString: sqlite3_column_text(queryStatement, 12)))
                let subject = String(describing: String(cString: sqlite3_column_text(queryStatement, 13)))
                let uCreatedDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 14)))
                let uLastIxnDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 15)))
                let caseid = String(describing: String(cString: sqlite3_column_text(queryStatement, 16)))
                
                psns.append(History(assignedToAgent: assignedToAgent, assignedToTeam: assignedToTeam, caseSource: caseSource, createdDate: createdDate, emailCC: emailCC, fullName: fullName, lastIxnBy: lastIxnBy, lastIxnDate: lastIxnDate, primaryEmail: primaryEmail, primaryPhone: primaryPhone, requestedBy: requestedBy, requestorRemark: requestorRemark, status: status, subject: subject, uCreatedDate: uCreatedDate, uLastIxnDate: uLastIxnDate, caseid: caseid))
            }
        } else {
            //print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
}
