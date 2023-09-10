//
//  StockItem.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import UIKit

import RealmSwift

class StockItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name:String = ""
    @Persisted var flag:Bool = false
    @Persisted var order:Int = 0
    
    static var demoItems:StockItem {
        let item = StockItem()
        item.name = "Item1"
        item.flag = false
        return item
    }
}
