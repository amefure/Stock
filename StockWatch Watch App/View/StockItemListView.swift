//
//  StockItemListView.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/06.
//

import SwiftUI

struct StockItemListView: View {
    
    @ObservedObject var iosConnector = iOSConnectViewModel.shared
    
    public let stock: Stock
    
     
    var body: some View {
        List {
            ForEach(stock.items) { item in
                HStack{
                    if item.name.prefix(1) != "-" {
                        Button {
                            iosConnector.sendCheckItemNotify(stockId: stock.id.stringValue, itemId: item.id.stringValue, flag: item.flag)
                        } label: {
                            Image(systemName: item.flag ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(.green)
                        }.buttonStyle(.plain)
                    }
                    Text(item.name)
                }
            }
        }
    }
}

#Preview {
    StockItemListView(stock: Stock.demoList)
}
