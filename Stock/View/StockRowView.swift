//
//  StockRowView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockRowView: View {
    let list:Stock
    @Binding var isDeleteMode:Bool
    var body: some View {
        HStack {
            Text("\(list.name)")
            Spacer()
            
            if isDeleteMode {
                Group {
                    Image(systemName: "trash")
                    Image(systemName: "arrow.left")
                    Image(systemName: "hand.tap")
                }.font(.caption)
                    .foregroundColor(.gray)
            }
        }.padding(8)
    }
}

struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockRowView(list: Stock.demoList, isDeleteMode: Binding.constant(true))
    }
}
