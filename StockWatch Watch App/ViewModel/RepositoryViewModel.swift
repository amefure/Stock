//
//  RepositoryViewModel.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/08.
//

import WatchKit
import RealmSwift

class RepositoryViewModel: ObservableObject {
    
    static let shared = RepositoryViewModel()
    private let repository = RealmRepository()
    
    @Published var stocks: Array<Stock> = []
    
    // MARK: - Stock
    public func readAllStock() {
        let results = repository.readAllStock()
        stocks.removeAll()
        stocks = Array(results).sorted(by: { $0.order < $1.order })
    }
        
    public func createStock(id: ObjectId, name: String, order: Int, items: List<StockItem>) {
        repository.createStock(id: id, name: name, order: order, items: items)
        self.readAllStock()
    }
    
    public func setAllStock(stocks: Array<Stock>) {
        guard stocks.count != 0 else { return }
        deleteAllStock()
        self.stocks.removeAll()
        self.stocks = stocks
        for stock in stocks {
            createStock(id: stock.id, name: stock.name, order: stock.order, items: stock.items)
        }
    }
    
    public func deleteAllStock() {
        repository.deleteAllStock()
    }
    
}

