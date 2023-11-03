//
//  StockItem.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import UIKit

import RealmSwift

class StockItem: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var flag: Bool = false
    @Persisted var order: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id, name, flag, order
    }

    convenience init(id: ObjectId, name: String, flag: Bool, order: Int) {
        self.init()
        self.id = id
        self.name = name
        self.flag = flag
        self.order = order
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(ObjectId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        flag = try container.decode(Bool.self, forKey: .flag)
        order = try container.decode(Int.self, forKey: .order)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(flag, forKey: .flag)
        try container.encode(order, forKey: .order)
    }
    
    static var demoItems:StockItem {
        let item = StockItem()
        item.name = "Item1"
        item.flag = false
        return item
    }
}
