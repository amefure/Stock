//
//  StockItemListView.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/06.
//

import SwiftUI

struct StockItemListView: View {
    
    public var stock: Stock
     
    var body: some View {
        List {
            ForEach(stock.items.sorted(by: { $0.order < $1.order })) { item in
                StockItemRowView(stock: stock, item: item)
            }
        }
    }
}

#Preview {
    StockItemListView(stock: Stock.demoList)
}
