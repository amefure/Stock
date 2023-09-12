//
//  StockRowView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockRowView: View {
    
    @ObservedObject var rootViewModel = RootViewModel.shared
    let list:Stock

    @State var name:String = ""
    
    var body: some View {
        HStack {
            if rootViewModel.currentMode == .edit {
                TextField(list.name, text: $name)
                    .padding(7.5)
                    .onChange(of: name) { newValue in
                        rootViewModel.updateStock(id: list.id, name: newValue)
                    }
            } else {
                Text("\(list.name)")
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            
            if rootViewModel.currentMode == .edit {
                Image(systemName: "pencil.tip.crop.circle")
                    .foregroundColor(.gray)
            } else if rootViewModel.currentMode == .delete {
                Group {
                    Image(systemName: "trash")
                    Image(systemName: "arrow.left")
                    Image(systemName: "hand.tap")
                }.font(.caption)
                    .foregroundColor(.gray)
            } else if rootViewModel.currentMode == .sort {
                
            }
        }.padding(8)
    }
}



struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockRowView(list: Stock.demoList)
    }
}
