//
//  StockRowView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI
import RealmSwift

struct StockRowView: View {
    
    @ObservedObject private var rootViewModel = RootViewModel.shared
    
    public let id:ObjectId
    public let displayName:String

    @State private var name:String = ""
    
    var body: some View {
        HStack {
            if rootViewModel.currentMode == .edit {
                TextField(displayName, text: $name)
                    .padding(7.5)
                    .onChange(of: name) { newValue in
                        rootViewModel.updateStock(id: id, name: newValue)
                    }
            } else {
                Text("\(displayName)")
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
        StockRowView(id: ObjectId(), displayName: "ame")
    }
}
