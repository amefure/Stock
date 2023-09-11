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
    
    public func deleteStock(_ stock:Stock) {
        repository.deleteStock(stock)
    }

}

