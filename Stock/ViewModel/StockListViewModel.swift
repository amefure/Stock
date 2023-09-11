//
//  StockListViewModel.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import UIKit
import RealmSwift

class StockListViewModel {
    
    private let repository: RepositoryProtocol = RealmRepository()
    
    public func createStock(name:String, order:Int) {
        repository.createStock(name: name, order: order)
    }
    
    public func updateStock(id:ObjectId,name:String) {
        repository.updateStock(id: id, name: name)
    }
    
    public func readStockList() -> Results<Stock> {
        return repository.readAllStock()
    }
    
    public func deleteStock(list:Results<Stock>, sourceSet:IndexSet) {
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
    }
    
    public func changeOrder(list:Results<Stock>, sourceSet:IndexSet, destination:Int) {
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
    }
    // MARK: - StockItem
}
