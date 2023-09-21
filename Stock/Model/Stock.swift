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
    
    public var size: Double {
        return Double(items.count)
    }
    
    public var checkItemsCnt: Double {
        let checkItems = items.filter({ $0.flag == true })
        return Double(checkItems.count)
    }
    
    public var exclusionItemsCnt: Double {
        let exclusionItems = items.filter({ $0.name.hasPrefix("-") })
        return Double(exclusionItems.count)
    }
    
    static var demoList: Stock {
        let list = Stock()
        list.name = "Test"
        let items = RealmSwift.List<StockItem>()
        items.append(objectsIn: [StockItem.demoItems, StockItem.demoItems])
        list.items = items
        return list
    }
}
