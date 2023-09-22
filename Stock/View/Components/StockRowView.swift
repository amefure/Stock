//
//  StockRowView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI
import RealmSwift

struct StockRowView: View {
    
    @ObservedObject private var repository = RepositoryViewModel.shared
    @ObservedObject private var rootViewModel = RootViewModel.shared
    
    public let id: ObjectId
    public let displayName: String
    public var stockItemFlag = false
    
    @State private var name: String = ""
    
    var body: some View {
        HStack {
            if rootViewModel.currentMode == .edit {
                TextField(displayName, text: $name)
                    .onChange(of: name) { newValue in
                        // 変更がないなら処理を行わない
                        if displayName != newValue {
                            if stockItemFlag {
                                repository.updateStockItem(listId: repository.currentStock.id ,itemId: id, name: newValue)
                            } else {
                                repository.updateStock(id: id, name: newValue)
                            }
                        }
                    }
            } else {
                
                if displayName.prefix(1) == "-" && stockItemFlag {
                    Group {
                        Text("■").padding(.trailing, 10)
                        Text("\(String(displayName.dropFirst()))")
                            .textSelection(.enabled)
                    }.fontWeight(.bold)
                        .offset(x: -8)
                } else {
                    Text("\(displayName)")
                        .textSelection(.enabled)
                        .foregroundColor(.white)
                }
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
            }
        }.padding(stockItemFlag ? 0 : 8)
            .onAppear {
                // TextFieldに初期値を格納
                name = displayName
            }
    }
}

struct StockRowView_Previews: PreviewProvider {
    static var previews: some View {
        StockRowView(id: ObjectId(), displayName: "ame")
    }
}
