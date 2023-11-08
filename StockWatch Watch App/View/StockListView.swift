//
//  ContentView.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/02.
//

import SwiftUI

struct StockListView: View {
    
    @ObservedObject var iosConnector = iOSConnectViewModel.shared
    @ObservedObject var repositoryViewModel = RepositoryViewModel.shared
    
    @State var isConnect: Bool = false
    
    var body: some View {
        NavigationStack {
            Asset.Images.stockLogo.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 60)
            List {
                if repositoryViewModel.stocks.count != 0 {
                    ForEach(repositoryViewModel.stocks.sorted(by: { $0.order < $1.order })) { stock in
                        NavigationLink {
                            StockItemListView(stock: stock)
                        } label: {
                            Text(stock.name)
                        }
                    }
                } else {
                    Text(L10n.watchNoData)
                        .onAppear {
                            /// ローカルからデータを取得する
                            repositoryViewModel.readAllStock()
                        }
                }
                
            }.padding()
        }
    }
}

#Preview {
    StockListView()
}
