//
//  StockItemRow.swift
//  StockWatch Watch App
//
//  Created by t&a on 2023/11/08.
//

import SwiftUI
import RealmSwift

struct StockItemRowView: View {
    
    @ObservedObject var iosConnector = iOSConnectViewModel.shared
    
    public let stock: Stock
    public var item: StockItem
    @State var isFlag = false
    @State var isAlert = false
    
    var body: some View {
        HStack{
            if item.name.prefix(1) != "-" {
                Button {
                    
                    if iosConnector.isConnenct {
                        isFlag.toggle()
                        iosConnector.sendCheckItemNotify(stockId: stock.id.stringValue, itemId: item.id.stringValue, flag: item.flag)
                    } else {
                        isAlert = true
                    }
                } label: {
                    Image(systemName: isFlag ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.green)
                }.buttonStyle(.plain)
                Text(item.name)
            } else {
                Group {
                    Text("■").padding(.horizontal, 10)
                    Text("\(String(item.name.dropFirst()))")
                }.fontWeight(.bold)
                    .offset(x: -8)
            }
        }
        .onAppear {
            isFlag = item.flag
        }
        .alert(isPresented: $isAlert) {
            Alert(title: Text(L10n.watchNoPairingAlertTitle),
                          message: Text(L10n.watchNoPairingAlertDesc),
                          dismissButton: .default(Text("OK")))
                }
    }
}

#Preview {
    StockItemRowView(stock: Stock.demoList, item: StockItem.demoItems)
}
