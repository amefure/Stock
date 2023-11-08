//
//  RealmRepository.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/08.
//

import WatchKit
import RealmSwift

class RealmRepository {
    
    // MARK: - private property
    private let realm = try! Realm()

    // MARK: - Stock
    public func createStock(id: ObjectId, name: String, order: Int, items: List<StockItem>) {
        try! realm.write {
            let stock = Stock()
            stock.id = id
            stock.name = name
            stock.order = order
            stock.items = items
            realm.add(stock)
        }
    }
    
    public func readAllStock() -> Results<Stock> {
        try! realm.write {
            let stocks = realm.objects(Stock.self)
            // Deleteでクラッシュするため凍結させる
            return stocks.freeze().sorted(byKeyPath: "id", ascending: true)
        }
    }
    
    public func deleteAllStock() {
        try! realm.write {
            realm.deleteAll()
        }
    }

}
