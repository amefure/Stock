//
//  RealmRepository.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import UIKit
import RealmSwift

protocol RepositoryProtocol {
    // Stock
    func createStock(name:String, order:Int)
    func updateStock(id:ObjectId, name:String)
    func readAllStock() -> Results<Stock>
    func deleteStock(_ list:Stock)
    
    // StockItem
    func createStockItem(listId:ObjectId, name:String, order:Int)
    func updateStockItem(itemId:ObjectId, name:String)
    func updateFlagStockItem(itemId:ObjectId, flag:Bool)
    func updateOrderStockItem(itemId:ObjectId, order:Int)
    func readStockItemList() -> Results<StockItem>
    func deleteStockItem(listId:ObjectId, itemId:ObjectId)
}

class RealmRepository: RepositoryProtocol {

    
    
    // MARK: - private property
    private let realm = try! Realm()

    // MARK: - Stock
    public func createStock(name:String, order:Int) {
        try! realm.write {
            let list = Stock()
            list.name = name
            list.order = order
            realm.add(list)
        }
    }
    
    public func updateStock(id:ObjectId,name:String) {
        try! realm.write {
            let lists = realm.objects(Stock.self)
            if let list = lists.where({$0.id == id}).first {
                list.name = name
            }
        }
    }
    
    // Read
    public func readSingleStock(id:ObjectId) -> Stock {
        return realm.objects(Stock.self).where({$0.id == id}).first!
    }
    
    public func readAllStock() -> Results<Stock> {
        try! realm.write {
            let lists = realm.objects(Stock.self)
            return lists.sorted(byKeyPath: "id",ascending: true)
        }
    }
    
    public func deleteStock(_ list:Stock) {
        try! self.realm.write{
            self.realm.delete(list)
        }
    }
    // MARK: - Stock
    
    // MARK: - StockItem
    func createStockItem(listId:ObjectId, name:String, order:Int) {
        try! realm.write {
            let list = realm.objects(Stock.self).filter{( $0.id == listId )}.first
            let item = StockItem()
            item.name = name
            item.order = order
            list?.items.append(item)
        }
    }
    
    func updateStockItem(itemId:ObjectId, name:String) {
        try! realm.write {
            let items = realm.objects(StockItem.self)
            if let item = items.where({$0.id == itemId}).first {
                item.name = name
            }
        }
    }
    
    func updateFlagStockItem(itemId:ObjectId, flag:Bool) {
        try! realm.write {
            let items = realm.objects(StockItem.self)
            if let item = items.where({$0.id == itemId}).first {
                item.flag = flag
            }
        }
    }
    
    func updateOrderStockItem(itemId:ObjectId, order:Int) {
        try! realm.write {
            let items = realm.objects(StockItem.self)
            if let item = items.where({$0.id == itemId}).first {
                item.order = order
            }
        }
    }
    
    func readStockItemList() -> Results<StockItem> {
        try! realm.write {
            let items = realm.objects(StockItem.self)
            return items.sorted(byKeyPath: "flag",ascending: true)
        }
    }

    public func deleteStockItem(listId:ObjectId, itemId:ObjectId) {
        try! realm.write{
            let record = readSingleStock(id:listId)
            let result =  record.items.where({$0.id == itemId }).first!
            realm.delete(result)
        }
    }
    // MARK: - StockItem
    
}

