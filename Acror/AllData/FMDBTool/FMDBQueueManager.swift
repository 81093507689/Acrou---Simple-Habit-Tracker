//
//  FMDBQueueManager.swift

import UIKit
import FMDB

class FMDBQueueManager: NSObject {

    static let shareFMDBQueueManager = FMDBQueueManager()
    
    var dbQueue : FMDatabaseQueue?
    
    func openDB(_ dbName : String)  {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        print("*******************************************************  ----------- > ",path)
        
        dbQueue = FMDatabaseQueue(path: "\(path)/\(dbName)")
      
        createTable()
        
       
        
    }
    //....Keychain access value
    //let getkeyvalue = Keychain.value(forKey: kappLastVersion) ?? "Not found"
    
    /*
     * Create Table in database
     * type cause -> 0 , resolution -> 1
     * section RBU 11 -> A , RBU 100 -> B , RBU 100 Sescor -> C , TCD 750 -> D
    */
    func createTable() -> Void {
        let sql_tbl = "CREATE TABLE IF NOT EXISTS NOTE ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE,'text' TEXT ,'detail' TEXT,'type' TEXT ,'howtime' TEXT)"
      
        dbQueue?.inDatabase({ (db) -> Void in
            try? db.executeUpdate(sql_tbl, values: [])
        })
        
        let sql_tbl2 = "CREATE TABLE IF NOT EXISTS DATA ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE,'noteid' INTEGER ,'dt' datetime )"
        
        dbQueue?.inDatabase({ (db) -> Void in
            try? db.executeUpdate(sql_tbl2, values: [])
        })
    }
    
   
    
    func insertDATA(getDateArray:[Date],getNoteID:String) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd "
       
        dateFormatter.timeZone = TimeZone.current
       // dateFormatter.timeZone = TimeZone(abbreviation: "GMT+5:30")
        
        
        dateFormatter.locale = Locale.current
        
         dbQueue?.inDatabase({ (db) ->Void in
            
            for i in 0..<getDateArray.count {
            
           let getDate:Date = getDateArray[i]
                print("getDate",getDate)
            let getFinalobjectDate = dateFormatter.string(from: getDate)
                print("getFinalobjectDate",getFinalobjectDate)


        
        let sql = "INSERT INTO DATA(noteid,dt) SELECT '\(getNoteID)','\(getFinalobjectDate)' WHERE NOT EXISTS(SELECT 1 FROM DATA WHERE noteid = '\(getNoteID)' AND dt = '\(getFinalobjectDate)');"
        
       
            
            try? db.executeUpdate(sql, values: [])
            
             print(Int(db.lastInsertRowId))
           
            
            }
            
            
        })
        
        

      //  return getlastid.description
    }
    
    
    func insertNote(getTitle:String,getDetail:String,getType:String,howTime:String)->Int {
        
    
        
        let sql = "INSERT INTO NOTE (text,detail,type,howtime) values ('\(getTitle)','\(getDetail)','\(getType)','\(howTime)')"
        var getId:Int = 0
        dbQueue?.inDatabase({ (db) ->Void in
            
            try? db.executeUpdate(sql, values: [])
            
            // print(Int(db.lastInsertRowId))
            getId = Int(db.lastInsertRowId)
            
            
            
            
        })
        
        
        return getId
        //  return getlastid.description
    }
    
    
    
    func deleteData(getcategoryid:String) {
        
        
        
        let sql = "DELETE FROM DATA where noteid = '\(getcategoryid)'"
        
        dbQueue?.inDatabase({ (db) ->Void in
            
            try? db.executeUpdate(sql, values: [])
            
            // print(Int(db.lastInsertRowId))
            //getId = Int(db.lastInsertRowId)
            
            
            
            
        })
        
        
        
        //  return getlastid.description
    }
    
    
    
    func GetDataByCategory(getNoteid:String)->[Date]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss Z"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let sql = "SELECT * FROM DATA where noteid = '\(getNoteid)'"
        
        var resultArray:[Date] = []
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    
                    let getdt = result.string(forColumn: "dt") ?? "2019-03-21"
                    print(getdt)
                    
                    let f = getdt + " 00:00:00 +0000"
                    
                    let getDate = dateFormatter.date(from: f)
                    
                    resultArray.append(getDate!)
                    
                    

                }
            }
            
        })
        return resultArray
    }
    
    
    func GetAllCategory()->NSMutableArray
    {
        let sql = "SELECT *, (SELECT Count(*) as c FROM DATA where noteid = NOTE.id) as total FROM NOTE"
        
        let resultArray:NSMutableArray = []
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    
                    let getid = result.string(forColumn: "id") ?? ""
                    let gettext = result.string(forColumn: "text") ?? ""
                    let getdt = result.string(forColumn: "detail") ?? ""
                    let getnotcompleted = result.string(forColumn: "total") ?? ""
                    let gettype = result.string(forColumn: "type") ?? ""
                    let gethowtime = result.string(forColumn: "howtime") ?? ""
                    
                    let createDic:NSMutableDictionary = NSMutableDictionary()
                    
                    createDic.setValue(getid, forKey: "id")
                    createDic.setValue(gettext, forKey: "text")
                    createDic.setValue(getdt, forKey: "detail")
                    createDic.setValue(getnotcompleted, forKey: "total")
                    createDic.setValue(gethowtime, forKey: "howtime")
                    createDic.setValue(gettype, forKey: "type")
                    resultArray.add(createDic)
                }
            }
            
        })
        return resultArray
    }
    
    
  
    
}
