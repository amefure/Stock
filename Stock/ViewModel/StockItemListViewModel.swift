//
//  StockItemListViewModel.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import UIKit
import RealmSwift

class StockItemListViewModel {
    
    private let repository: RepositoryProtocol = RealmRepository()
    
    // MARK: - StockItem
    public func createStockItem(listId:ObjectId, name:String, order:Int) {
        repository.createStockItem(stockId: listId, name: name, order: order)
    }
    
    public func updateStockItem(itemId:ObjectId,name:String) {
        repository.updateStockItem(itemId: itemId, name: name)
    }
    
    public func updateFlagStockItem(itemId:ObjectId,flag:Bool) {
        repository.updateFlagStockItem(itemId: itemId, flag: flag)
    }
    
    public func readStockItemList() -> Results<StockItem> {
        return repository.readStockItemList()
    }
    
    public func deleteStockItem(list:Stock, sourceSet:IndexSet, listId:ObjectId, itemId:ObjectId) {
        guard let source = sourceSet.first else { return }
        
        let items = list.items.sorted(by: { $0.order < $1.order })
        // 削除する行のIDを取得
        let deleteId = items[source].id
        // 削除する行の行番号を取得
        let deleteOrder = items[source].order
        
        // 削除する行の行番号より大きい行番号を全て -1 する
        for i in (deleteOrder + 1)..<items.count {
            repository.updateOrderStockItem(itemId: items[i].id, order: items[i].order - 1)
        }
        repository.deleteStockItem(stockId:listId, itemId:itemId)
    }
    
    public func changeOrder(list:Stock, sourceSet:IndexSet, destination:Int) {
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
    }
    // MARK: - StockItem
}
