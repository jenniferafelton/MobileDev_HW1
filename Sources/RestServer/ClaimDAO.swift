//
//  ClaimDAO.swift
//  RestServer
//
//  Created by jennifer felton on 10/26/20.
//

import Foundation
import SQLite3

struct Claim : Codable {
    var id : String
    var title : String?
    var date : String?
    var isSolved : Bool
    
    init(i: String, t: String?, d: String?, solve: Bool){
        id = i
        title = t
        date = d
        isSolved = solve
    }
    
}

class ClaimDAO{
    func addClaim(cObj : Claim){
        let sqlStmt = String(format:"insert into claim (id, title, date, isSolved) values ('%@', '%@', '%@', 0)", cObj.id, (cObj.title)!, (cObj.date)!)
        // get database connection
        let conn = Database.getInstance().getDbConnection()
        // submit the insert sql statement
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a claim record due to error \(errcode)")
        }
        // close the connection
        sqlite3_close(conn)
        
    }
    
    func getAll() -> [Claim] {
        var cList = [Claim]()
        var resultSet : OpaquePointer?
        let sqlStr = "select id, title, date, is solved from claim"
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW) {
                // Convert the record into a Person object
                // Unsafe_Pointer<CChar> Sqlite3
                let id_val = sqlite3_column_text(resultSet, 0)
                let id = String(cString: id_val!)
                
                let title_val = sqlite3_column_text(resultSet, 1)
                let title = String(cString: title_val!)
                
                let date_val = sqlite3_column_text(resultSet, 2)
                let date = String(cString: date_val!)
                
                let isSolved_val = sqlite3_column_int(resultSet, 3)
                let isSolved = Bool(truncating: isSolved_val as NSNumber)
                
                cList.append(Claim(i:id, t:title, d:date, solve:isSolved))
            }
        }
        return cList
    }
    
}


