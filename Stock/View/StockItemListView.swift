//
//  StockItemListView.swift
//  Stock
//
//  Created by t&a on 2023/09/10.
//

import SwiftUI

struct StockItemListView: View {
    private let viewModel = StockItemListViewModel()
    
    let list:Stock
    @State var name = ""
    
    @State var itemNames:[String] = [""]
    
    var body: some View {
        VStack{
            HStack {
                TextField("", text: $name)
                Button {
                    if name.isEmpty { return }
                    viewModel.createStockItem(listId: list.id, name: name, order: list.size)
                    name = ""
                    itemNames.append("")
                } label: {
                    Image(systemName: "plus")
                }
                
            }
            
            List {
                ForEach(list.items.sorted(byKeyPath: "order")){ item in
                    HStack{
                        Button {
                            viewModel.updateFlagStockItem(itemId: item.id, flag: !item.flag)
                        } label: {
                            Image(systemName: item.flag ? "checkmark.circle" : "circle")
                                .foregroundColor( item.flag ? .yellow : .white)
                        }.buttonStyle(.plain)
                        Text(item.name)
//                        TextField(item.name, text: $itemNames[item.order])
//                            .onChange(of: itemNames[item.order]) { newValue in
//                                    viewModel.updateStockItem(itemId: item.id, name: newValue)
//                            }
                        
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteStockItem(listId: list.id, itemId: item.id)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }.onMove { sourceSet, destination in
                    viewModel.changeOrder(list: list, sourceSet: sourceSet, destination: destination)
                    itemNames.removeAll()
                    for item in list.items.sorted(byKeyPath: "order") {
                        itemNames.append(item.name)
                    }
                }
                
            }.navigationTitle(list.name)
                .toolbar { EditButton() }
                .onAppear {
                    itemNames.removeAll()
                    for item in list.items.sorted(byKeyPath: "order") {
                        itemNames.append(item.name)
                    }
                }
        }
    }
}


struct StockItemListView_Previews: PreviewProvider {
    static var previews: some View {
        StockItemListView(list: Stock.demoList)
    }
}
