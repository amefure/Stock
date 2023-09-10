//
//  Stock.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import UIKit
import RealmSwift

class Stock: Object,ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name:String = ""
    @Persisted var items = RealmSwift.List<StockItem>()
    @Persisted var order:Int = 0
    
    public var size:Int {
        return items.count
    }
    
    static var demoList:Stock {
        let list = Stock()
        list.name = "Test"
        let items = RealmSwift.List<StockItem>()
        items.append(objectsIn: [StockItem.demoItems, StockItem.demoItems])
        list.items = items
        return list
    }
}
