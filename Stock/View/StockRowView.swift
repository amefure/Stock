//
//  StockRowView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockRowView: View {
    let list:Stock
    var body: some View {
        HStack {
            Text("\(list.name)")
        }.padding(8)
    }
}

struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockRowView(list: Stock.demoList)
    }
}
