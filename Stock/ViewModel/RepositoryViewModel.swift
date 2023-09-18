//
//  RepositoryViewModel.swift
//  Stock
//
//  Created by t&a on 2023/09/13.
//

import UIKit
import RealmSwift

class RepositoryViewModel: ObservableObject {
    
    static let shared = RepositoryViewModel()
    private let repository: RepositoryProtocol = RealmRepository()
    
    @Published var stocks: Array<Stock> = []
    @Published var currentStock = Stock()
    @Published var currentItems: Array<StockItem> = []
    
    // MARK: - Stock
    public func readAllStock() {
        let results = repository.readAllStock()
        stocks.removeAll()
        stocks = Array(results).sorted(by: { $0.order < $1.order })
    }
    
    public func setCurrentStock(id: ObjectId) {
        if let result = stocks.first(where: { $0.id == id }) {
            currentStock = result
            currentItems =  Array(currentStock.items).sorted(by: { $0.order < $1.order })
        }
    }
    
    public func createStock(name:String, order:Int) {
        repository.createStock(name: name, order: order)
        self.readAllStock()
    }
    
    public func updateStock(id: ObjectId, name: String) {
        repository.updateStock(id: id, name: name)
        self.readAllStock()
    }
    
    public func deleteStock(list: Array<Stock>, sourceSet: IndexSet) {
        guard let source = sourceSet.first else { return }
        
        let items = list.sorted(by: { $0.order < $1.order })
        // 削除する行のIDを取得
        let deleteId = items[source].id
        // 削除する行の行番号を取得
        let deleteOrder = items[source].order
        
        // 削除する行の行番号より大きい行番号を全て -1 する
        for i in (deleteOrder + 1)..<items.count {
            repository.updateOrderStock(id: items[i].id, order: items[i].order - 1)
        }
        repository.deleteStock(id: deleteId)
        self.readAllStock()
    }
    
    public func changeOrder(list: Array<Stock>, sourceSet: IndexSet, destination: Int) {
        guard let source = sourceSet.first else { return }
        
        let items = list.sorted(by: { $0.order < $1.order })
        
        let moveId = items[source].id
        
        // 上から下に移動する
        if source < destination {
            for i in (source + 1)...(destination - 1) {
                repository.updateOrderStock(id: items[i].id, order: items[i].order - 1)
            }
            repository.updateOrderStock(id: moveId, order: destination - 1)
            
            // 下から上に移動する
        } else if destination < source {
            for i in (destination...(source - 1)).reversed() {
                repository.updateOrderStock(id: items[i].id, order: items[i].order + 1)
            }
            repository.updateOrderStock(id: moveId, order: destination)
        }
        self.readAllStock()
    }
    // MARK: - Stock
    
    // MARK: - StockItem
    public func createStockItem(listId:ObjectId, name:String, order:Int) {
        repository.createStockItem(stockId: listId, name: name, order: order)
        self.readAllStock()
        self.setCurrentStock(id: listId)
    }
    
    public func updateStockItem(listId:ObjectId, itemId:ObjectId,name:String) {
        repository.updateStockItem(itemId: itemId, name: name)
        self.readAllStock()
        self.setCurrentStock(id: listId)
    }
    
    public func updateFlagStockItem(listId:ObjectId, itemId:ObjectId,flag:Bool) {
        repository.updateFlagStockItem(itemId: itemId, flag: flag)
        self.readAllStock()
        self.setCurrentStock(id: listId)
    }
    
    public func readStockItemList() -> Results<StockItem> {
        return repository.readStockItemList()
    }
    
    public func deleteStockItem(list:Stock, sourceSet:IndexSet, listId:ObjectId) {
        guard let source = sourceSet.first else { return }
        let items2 = list.items.sorted(by: { $0.order < $1.order })
        let items = Array(items2)

        // 削除する行のIDを取得
        let deleteId = items[source].id
        // 削除する行の行番号を取得
        let deleteOrder = items[source].order
        // 削除する行の行番号より大きい行番号を全て -1 する
        for i in (deleteOrder + 1)..<items.count {
            repository.updateOrderStockItem(itemId: items[i].id, order: items[i].order - 1)
        }
        repository.deleteStockItem(stockId:listId, itemId:deleteId)
        // 全体の更新
        self.readAllStock()
        // 表示Stockの更新
        self.setCurrentStock(id: listId)
        
    }
    
    public func changeOrderStockItem(list:Stock, sourceSet:IndexSet, destination:Int) {
        guard let source = sourceSet.first else { return }
        
        let items = list.items.sorted(by: { $0.order < $1.order })
        
        let moveId = items[source].id
        
        // 上から下に移動する
        if source < destination {
            for i in (source + 1)...(destination - 1) {
                repository.updateOrderStockItem(itemId: items[i].id, order: items[i].order - 1)
            }
            repository.updateOrderStockItem(itemId: moveId, order: destination - 1)
            
            // 下から上に移動する
        } else if destination < source {
            for i in (destination...(source - 1)).reversed() {
                repository.updateOrderStockItem(itemId: items[i].id, order: items[i].order + 1)
            }
            repository.updateOrderStockItem(itemId: moveId, order: destination)
        }
        self.readAllStock()
        self.setCurrentStock(id: list.id)
    }
    // MARK: - StockItem
}

