//
//  Stock.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import UIKit
import RealmSwift

class Stock: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var items = RealmSwift.List<StockItem>()
    @Persisted var order: Int = 0

    enum CodingKeys: String, CodingKey {
        case id, name, items, order
    }

    convenience init(id: ObjectId, name: String, items: RealmSwift.List<StockItem>, order: Int) {
        self.init()
        self.id = id
        self.name = name
        self.items = items
        self.order = order
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(ObjectId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        if let itemsArray = try container.decodeIfPresent([StockItem].self, forKey: .items) {
            items.removeAll()
            items.append(objectsIn: itemsArray)
        }
        order = try container.decode(Int.self, forKey: .order)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)

        let itemsArray = Array(items)
        try container.encode(itemsArray, forKey: .items)
        try container.encode(order, forKey: .order)
    }


    
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
