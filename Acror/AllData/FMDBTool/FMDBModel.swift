//
//  FMDBModel.swift
//  SwiftFMDBDemo


import UIKit

class FMDBModel: NSObject {
    var name : String? = ""
    var phoneNum : String? = ""
    var user_id : String? = ""
    var serverchat_id : String? = ""
    var sender_id : String? = ""
    var type : String? = ""
    var error : String? = ""
    var message : String? = ""
    var read:String? = ""
    var date:String? = ""
    var cart:NSDictionary = NSDictionary()
    var chanelname:String? = ""
    var order_id:String? = ""
    var totalOrderPrice = ""
    var orderReferenceNumber = ""
    
    init(dict: [String:String]) {
        super.init()
        setValuesForKeys(dict)
    }
   
    /*
     * Any new message sending that time this is working
     * Anew new message getting that time this is working
     * one condition user is message screen (User is Online)
    */
    func insertNewCauses(getText:String,getfieldid:String,getType:String) -> String {
        
      var getlastid = 0
        
//   id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE,'text' TEXT,'fieldid' TEXT,'type' TEXT
      
        let sql = "INSERT INTO chat_tbl (text,fieldid,type) values ('\(getText)','\(getfieldid)','\(getType)')"
        
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) ->Void in
            
            try? db.executeUpdate(sql, values: [])
            
            getlastid = Int(db.lastInsertRowId)
            
            
          
                
           
        })
        
       

        return getlastid.description
    }
    
    /*
     * Any new message sending that time this is working
     * One condition user is Not on message screen (User is Offline)
     * when user on Home screen, Profile screen , setting screen that time we are getting any new message
     */
   
    
    /*
     * First time come on message screen , all message load from Data base
     */
   class func getAllMessage(getReceiverId:String, getOFfset:Int)->NSMutableArray {
        
        let sql = "SELECT * FROM tbl"
        let resultArray:NSMutableArray = []
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            if let result = try? db.executeQuery(sql, values: []){
                while (result.next()) {
                    let serverchat_id = result.string(forColumn: "serverchat_id") ?? ""
                    let chat_id = result.string(forColumn: "chat_id")
                    let user_id = result.string(forColumn: "user_id")
                    let receiver_id = result.string(forColumn: "receiver_id")
                    
                    let type = result.string(forColumn: "type") ?? ""
                    let error:String = result.string(forColumn: "error") ?? ""
                    let message:String = result.string(forColumn: "message") ?? ""
                    let product:String = (result.string(forColumn: "product")) ?? ""
                    let html:String = result.string(forColumn: "html") ?? ""
                    let prod_id:String = result.string(forColumn: "id_pro") ?? ""
                    let offer:String = result.string(forColumn: "offer") ?? ""
                    let totalPrice:String = result.string(forColumn: "totalPrice") ?? ""
                    let read:String = result.string(forColumn: "read") ?? ""
                    let Time:String = result.string(forColumn: "date") ?? ""
                    let orderid:String = result.string(forColumn: "order_id") ?? ""
                    let orderReferenceNumber:String = result.string(forColumn: "orderReferenceNumber") ?? ""
                    let chanelname:String = result.string(forColumn: "chanel_name") ?? ""
                    var ifHideDate:Bool = false
                  
                }
            }
            
        })
        return resultArray
        
    }
    
    class func updateMessagesErrorStatus_doubleCheckMark(getchannelName : String){
        let sql = "update chat_tbl set error = '2' where chanel_name ='\(getchannelName)' AND ((error = '0') OR (error = '1'))"
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) in
            try? db.executeUpdate(sql, values: [])
        })
    }
    
    
    /*
     * Remove product from selected cart
     */
    class func removeCart(cartid:String) -> Void
    {
        let sql = "DELETE FROM addtocart_tbl WHERE id_cart = '\(cartid)' "
        FMDBQueueManager.shareFMDBQueueManager.dbQueue?.inDatabase({ (db) ->Void in
            try? db.executeUpdate(sql, values: [])
        })
    }// end function
    
   
}
