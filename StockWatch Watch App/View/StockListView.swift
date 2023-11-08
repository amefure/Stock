//
//  ContentView.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/02.
//

import SwiftUI

struct StockListView: View {
    
    @ObservedObject var iosConnector = iOSConnectViewModel.shared
    @State var isConnect: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(iosConnector.stocks) { stock in
                    NavigationLink {
                        StockItemListView(stock: stock)
                    } label: {
                        Text(stock.name)
                    }
                }
            }.padding()
        }
    }
}

#Preview {
    StockListView()
}
