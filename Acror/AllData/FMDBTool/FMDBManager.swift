//
//  FMDBManager.swift


import UIKit
import FMDB

class FMDBManager: NSObject {
    static let ShareManager = FMDBManager()
    var db: FMDatabase?
    
    func openDB(_ dbName: String) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        db = FMDatabase(path: "\(path)/\(dbName)")
        if db!.open() {
            createTalbe()
        }
    }
  
    func createTalbe() {
        let sql = ""
        do {
            try db?.executeUpdate(sql, values: [])
        } catch  {
            print(error)
        }
    }
    
}
